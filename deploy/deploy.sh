#!/bin/bash
set -euo pipefail

###############################################################################
# Smart School TVET — Production Deployment Script
# Server: 4.221.231.33 (Ubuntu 22.04)
# Domain: northlinkcollegelms.smartgov.co.za
# Database: Azure MySQL lms-sql-server.mysql.database.azure.com
###############################################################################

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log()   { echo -e "${GREEN}[DEPLOY]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

###############################################################################
# Configuration
###############################################################################

DOMAIN="northlinkcollegelms.smartgov.co.za"
SITE_URL="https://${DOMAIN}/"

# Paths
OLD_APP_DIR="/var/www/smart-school"
NEW_APP_DIR="/var/www/smart-school-tvet"
BACKUP_DIR="/var/www/backups"

# Azure MySQL
DB_HOST="lms-sql-server.mysql.database.azure.com"
DB_USER="boxadmin"
DB_PASS="47X41h1ltOVY"
DB_NAME_OLD="smart_school"
DB_NAME_NEW="smart_school_tvet"

# Super Admin
ADMIN_EMAIL="Blackrawone@gmail.com"
ADMIN_PASSWORD='ZEUm^9FUpduK^y5WRxM4'

###############################################################################
# Pre-flight checks
###############################################################################

log "Starting Smart School TVET production deployment..."
log "Domain: ${DOMAIN}"
log "Server: $(hostname)"

if [ "$(id -u)" -ne 0 ]; then
    error "This script must be run as root (use sudo)"
fi

###############################################################################
# Step 1: Backup current system
###############################################################################

log "=== Step 1: Backing up current system ==="

mkdir -p "${BACKUP_DIR}"

if [ -d "${OLD_APP_DIR}" ]; then
    BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)

    log "Archiving application files..."
    tar czf "${BACKUP_DIR}/smart-school-backup-${BACKUP_TIMESTAMP}.tar.gz" \
        -C /var/www smart-school/ 2>/dev/null || warn "App archive had warnings (may be permissions)"

    log "Dumping current database..."
    mysqldump -h "${DB_HOST}" -u "${DB_USER}" -p"${DB_PASS}" \
        --ssl-mode=REQUIRED --single-transaction --routines --triggers \
        "${DB_NAME_OLD}" > "${BACKUP_DIR}/smart_school_db_backup_${BACKUP_TIMESTAMP}.sql" 2>/dev/null \
        || warn "DB dump had warnings"

    # Verify backups
    APP_BACKUP_SIZE=$(stat -c%s "${BACKUP_DIR}/smart-school-backup-${BACKUP_TIMESTAMP}.tar.gz" 2>/dev/null || echo "0")
    DB_BACKUP_SIZE=$(stat -c%s "${BACKUP_DIR}/smart_school_db_backup_${BACKUP_TIMESTAMP}.sql" 2>/dev/null || echo "0")

    if [ "$APP_BACKUP_SIZE" -lt 1000 ]; then
        warn "App backup seems small (${APP_BACKUP_SIZE} bytes) — check manually"
    else
        log "App backup: ${APP_BACKUP_SIZE} bytes"
    fi

    if [ "$DB_BACKUP_SIZE" -lt 1000 ]; then
        warn "DB backup seems small (${DB_BACKUP_SIZE} bytes) — check manually"
    else
        log "DB backup: ${DB_BACKUP_SIZE} bytes"
    fi
else
    warn "No existing app at ${OLD_APP_DIR} — skipping backup"
fi

log "Step 1 complete."

###############################################################################
# Step 2: Install Docker (if not present) + add swap
###############################################################################

log "=== Step 2: Installing Docker and adding swap ==="

if ! command -v docker &> /dev/null; then
    log "Installing Docker..."
    apt-get update -qq
    apt-get install -y -qq docker.io docker-compose
    systemctl enable docker
    systemctl start docker
    log "Docker installed."
else
    log "Docker already installed: $(docker --version)"
fi

# Add boxadmin to docker group (if user exists)
if id "boxadmin" &>/dev/null; then
    usermod -aG docker boxadmin 2>/dev/null || true
fi

# Add swap if not present
SWAP_TOTAL=$(free -m | awk '/Swap/{print $2}')
if [ "${SWAP_TOTAL}" -lt 100 ]; then
    log "Adding 1GB swap file..."
    if [ ! -f /swapfile ]; then
        fallocate -l 1G /swapfile
        chmod 600 /swapfile
        mkswap /swapfile
        swapon /swapfile
        echo '/swapfile none swap sw 0 0' >> /etc/fstab
        log "Swap added: $(free -m | awk '/Swap/{print $2}')MB"
    else
        warn "/swapfile already exists"
        swapon /swapfile 2>/dev/null || true
    fi
else
    log "Swap already present: ${SWAP_TOTAL}MB"
fi

log "Step 2 complete."

###############################################################################
# Step 3: Create new database and import schema
###############################################################################

log "=== Step 3: Setting up TVET database ==="

MYSQL_CMD="mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASS} --ssl-mode=REQUIRED"

log "Creating database ${DB_NAME_NEW}..."
${MYSQL_CMD} -e "CREATE DATABASE IF NOT EXISTS \`${DB_NAME_NEW}\` CHARACTER SET utf8 COLLATE utf8_general_ci;" 2>/dev/null

log "Setting SQL_MODE (disable ONLY_FULL_GROUP_BY)..."
${MYSQL_CMD} -e "SET GLOBAL sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';" 2>/dev/null || warn "Could not set global sql_mode (may need Azure admin)"

# Import schema
SCHEMA_FILE="${NEW_APP_DIR}/docker/init/001_tvet_complete_database.sql"
SEED_FILE="${NEW_APP_DIR}/docker/init/002_seed_data.sql"

if [ -f "${SCHEMA_FILE}" ]; then
    log "Importing schema (001_tvet_complete_database.sql)..."
    ${MYSQL_CMD} "${DB_NAME_NEW}" < "${SCHEMA_FILE}" 2>/dev/null
    log "Schema imported."
else
    error "Schema file not found: ${SCHEMA_FILE}"
fi

if [ -f "${SEED_FILE}" ]; then
    log "Importing seed data (002_seed_data.sql)..."
    ${MYSQL_CMD} "${DB_NAME_NEW}" < "${SEED_FILE}" 2>/dev/null
    log "Seed data imported."
else
    error "Seed file not found: ${SEED_FILE}"
fi

# Verify table count
TABLE_COUNT=$(${MYSQL_CMD} -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${DB_NAME_NEW}';" 2>/dev/null)
log "Tables created: ${TABLE_COUNT}"

if [ "${TABLE_COUNT}" -lt 150 ]; then
    warn "Expected ~193 tables, got ${TABLE_COUNT} — check import logs"
fi

log "Step 3 complete."

###############################################################################
# Step 4: Deploy app with Docker
###############################################################################

log "=== Step 4: Deploying application ==="

# Ensure app directory exists
# NOTE: Before running this script, copy the repo to the server:
#   scp -r /path/to/Smart-School-Git-Repo boxadmin@4.221.231.33:/var/www/smart-school-tvet
# Or use git clone if the repo is accessible from the server.
if [ ! -d "${NEW_APP_DIR}/smart_school_src" ]; then
    error "Application not found at ${NEW_APP_DIR}/smart_school_src — copy the repo to the server first.
    From your local machine:
      rsync -avz --exclude='.git' --exclude='node_modules' /path/to/Smart-School-Git-Repo/ boxadmin@4.221.231.33:${NEW_APP_DIR}/
    Or:
      scp -r /path/to/Smart-School-Git-Repo boxadmin@4.221.231.33:${NEW_APP_DIR}"
else
    log "Application found at ${NEW_APP_DIR}"
fi

# Create database.php for production (connecting to Azure MySQL)
log "Creating production database config..."
cat > "${NEW_APP_DIR}/smart_school_src/application/config/database.php" <<DBEOF
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

\$active_group = 'default';
\$query_builder = TRUE;

\$db['default'] = array(
    'dsn' => '',
    'hostname' => '${DB_HOST}',
    'username' => '${DB_USER}',
    'password' => '${DB_PASS}',
    'database' => '${DB_NAME_NEW}',
    'dbdriver' => 'mysqli',
    'dbprefix' => '',
    'pconnect' => FALSE,
    'db_debug' => FALSE,
    'cache_on' => FALSE,
    'cachedir' => '',
    'char_set' => 'utf8',
    'dbcollat' => 'utf8_general_ci',
    'swap_pre' => '',
    'encrypt' => array('ssl_verify' => FALSE),
    'compress' => FALSE,
    'stricton' => FALSE,
    'failover' => array(),
    'save_queries' => FALSE
);
DBEOF

# Set environment to production in index.php
sed -i "s/define('ENVIRONMENT', 'development')/define('ENVIRONMENT', 'production')/" \
    "${NEW_APP_DIR}/smart_school_src/index.php"

# Copy production entrypoint into docker build context
cp "${NEW_APP_DIR}/deploy/docker-entrypoint-production.sh" \
   "${NEW_APP_DIR}/docker/docker-entrypoint-production.sh"
chmod +x "${NEW_APP_DIR}/docker/docker-entrypoint-production.sh"

# Create production docker-compose with proper env vars
cat > "${NEW_APP_DIR}/docker-compose.production.yml" <<DCEOF
version: '3.8'

services:
  web:
    build:
      context: .
      dockerfile: deploy/Dockerfile.production
    container_name: smartschool-tvet
    restart: unless-stopped
    ports:
      - "127.0.0.1:8080:80"
    volumes:
      - ./smart_school_src/uploads:/var/www/html/smart_school_src/uploads
      - ./deploy/logs:/var/www/html/smart_school_src/application/logs
    environment:
      - SITE_URL=https://${DOMAIN}/
      - DB_HOST=${DB_HOST}
      - DB_USER=${DB_USER}
      - DB_PASS=${DB_PASS}
      - DB_NAME=${DB_NAME_NEW}
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
DCEOF

# Build and start
log "Building Docker image..."
cd "${NEW_APP_DIR}"
mkdir -p deploy/logs
docker-compose -f docker-compose.production.yml build

log "Starting Docker container..."
docker-compose -f docker-compose.production.yml up -d

# Wait for container to be healthy
log "Waiting for container to start..."
sleep 10

CONTAINER_STATUS=$(docker ps --filter "name=smartschool-tvet" --format "{{.Status}}" 2>/dev/null)
if echo "${CONTAINER_STATUS}" | grep -q "Up"; then
    log "Container running: ${CONTAINER_STATUS}"
else
    error "Container failed to start. Check: docker logs smartschool-tvet"
fi

# Quick health check
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/ 2>/dev/null || echo "000")
if [ "${HTTP_CODE}" = "200" ] || [ "${HTTP_CODE}" = "302" ]; then
    log "App responding on localhost:8080 (HTTP ${HTTP_CODE})"
else
    warn "App returned HTTP ${HTTP_CODE} on localhost:8080 — check container logs"
fi

log "Step 4 complete."

###############################################################################
# Step 5: Copy uploads from old deployment
###############################################################################

log "=== Step 5: Copying uploads ==="

if [ -d "${OLD_APP_DIR}/smart_school_src/uploads" ]; then
    log "Copying uploads from old deployment..."
    rsync -a --ignore-existing \
        "${OLD_APP_DIR}/smart_school_src/uploads/" \
        "${NEW_APP_DIR}/smart_school_src/uploads/"
    chown -R www-data:www-data "${NEW_APP_DIR}/smart_school_src/uploads/"
    log "Uploads copied."
else
    warn "No uploads directory found at ${OLD_APP_DIR}/smart_school_src/uploads"
fi

log "Step 5 complete."

###############################################################################
# Step 6: Create Super Admin user
###############################################################################

log "=== Step 6: Creating Super Admin user ==="

# Generate bcrypt hash using PHP inside the container
PASS_HASH=$(docker exec smartschool-tvet php -r "echo password_hash('${ADMIN_PASSWORD}', PASSWORD_BCRYPT);" 2>/dev/null)

if [ -z "${PASS_HASH}" ]; then
    error "Failed to generate password hash"
fi

log "Password hash generated."

# Create temporary SQL with the actual hash
ADMIN_SQL=$(cat "${NEW_APP_DIR}/deploy/003_create_super_admin.sql" | sed "s|__PASSWORD_HASH__|${PASS_HASH}|g")

echo "${ADMIN_SQL}" | ${MYSQL_CMD} "${DB_NAME_NEW}" 2>/dev/null \
    && log "Super Admin created: ${ADMIN_EMAIL}" \
    || warn "Super Admin may already exist (duplicate email)"

log "Step 6 complete."

###############################################################################
# Step 7: Configure Nginx + SSL
###############################################################################

log "=== Step 7: Configuring Nginx ==="

# Install nginx if needed
if ! command -v nginx &> /dev/null; then
    log "Installing Nginx..."
    apt-get install -y -qq nginx
fi

systemctl enable nginx

# Check for existing SSL certs
SSL_CERT="/etc/letsencrypt/live/${DOMAIN}/fullchain.pem"
SSL_KEY="/etc/letsencrypt/live/${DOMAIN}/privkey.pem"

if [ ! -f "${SSL_CERT}" ] || [ ! -f "${SSL_KEY}" ]; then
    warn "SSL certificates not found at ${SSL_CERT}"
    warn "You'll need to set up SSL manually with: certbot --nginx -d ${DOMAIN}"
    warn "For now, deploying HTTP-only nginx config..."

    # HTTP-only fallback config
    cat > /etc/nginx/sites-available/smartschool-tvet <<NGEOF
server {
    listen 80;
    server_name ${DOMAIN};

    client_max_body_size 64M;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_connect_timeout 60s;
        proxy_send_timeout 300s;
        proxy_read_timeout 300s;
    }

    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }
}
NGEOF

else
    log "SSL certificates found, deploying HTTPS config..."
    cp "${NEW_APP_DIR}/deploy/nginx-site.conf" /etc/nginx/sites-available/smartschool-tvet
fi

# Enable the site
ln -sf /etc/nginx/sites-available/smartschool-tvet /etc/nginx/sites-enabled/smartschool-tvet

# Remove default site if it exists
rm -f /etc/nginx/sites-enabled/default 2>/dev/null || true

# Test nginx config
nginx -t 2>&1 || error "Nginx config test failed!"

log "Step 7 complete."

###############################################################################
# Step 8: Switch over — stop Apache, start Nginx
###############################################################################

log "=== Step 8: Switching over ==="

# Stop and disable Apache
if systemctl is-active apache2 &>/dev/null; then
    log "Stopping Apache..."
    systemctl stop apache2
    systemctl disable apache2
    log "Apache stopped and disabled."
else
    log "Apache not running."
fi

# Start/reload Nginx
log "Starting Nginx..."
systemctl restart nginx

# Final health checks
sleep 3

log "=== Final Health Checks ==="

# Check Docker container
CONTAINER_UP=$(docker ps --filter "name=smartschool-tvet" --format "{{.Status}}" 2>/dev/null)
log "Docker container: ${CONTAINER_UP}"

# Check Nginx
NGINX_UP=$(systemctl is-active nginx 2>/dev/null)
log "Nginx: ${NGINX_UP}"

# Check site via localhost
HTTP_LOCAL=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:8080/ 2>/dev/null || echo "000")
log "Local HTTP check (port 8080): ${HTTP_LOCAL}"

# Check site via domain
HTTP_DOMAIN=$(curl -sk -o /dev/null -w "%{http_code}" "https://${DOMAIN}/" 2>/dev/null || echo "000")
if [ "${HTTP_DOMAIN}" = "000" ]; then
    HTTP_DOMAIN=$(curl -s -o /dev/null -w "%{http_code}" "http://${DOMAIN}/" 2>/dev/null || echo "000")
    log "Domain HTTP check: ${HTTP_DOMAIN}"
else
    log "Domain HTTPS check: ${HTTP_DOMAIN}"
fi

log ""
log "============================================="
log "  Deployment complete!"
log "============================================="
log ""
log "  URL:    https://${DOMAIN}/"
log "  Admin:  ${ADMIN_EMAIL}"
log "  DB:     ${DB_NAME_NEW} on ${DB_HOST}"
log ""
log "  Useful commands:"
log "    docker logs -f smartschool-tvet     # View app logs"
log "    docker exec -it smartschool-tvet bash  # Shell into container"
log "    docker-compose -f ${NEW_APP_DIR}/docker-compose.production.yml restart  # Restart app"
log ""
log "  ROLLBACK (if needed):"
log "    docker-compose -f ${NEW_APP_DIR}/docker-compose.production.yml down"
log "    systemctl enable apache2 && systemctl start apache2"
log "    # Old system at ${OLD_APP_DIR} is untouched"
log ""
