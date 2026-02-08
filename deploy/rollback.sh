#!/bin/bash
set -euo pipefail

###############################################################################
# Smart School TVET — Rollback Script
# Stops Docker deployment and restores Apache-based old system
###############################################################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log()   { echo -e "${GREEN}[ROLLBACK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

NEW_APP_DIR="/var/www/smart-school-tvet"

if [ "$(id -u)" -ne 0 ]; then
    error "This script must be run as root (use sudo)"
fi

log "Rolling back to previous deployment..."

# Stop Docker container
if docker ps --filter "name=smartschool-tvet" --format "{{.Names}}" 2>/dev/null | grep -q smartschool-tvet; then
    log "Stopping Docker container..."
    cd "${NEW_APP_DIR}" && docker-compose -f docker-compose.production.yml down 2>/dev/null || true
fi

# Remove nginx TVET config
if [ -f /etc/nginx/sites-enabled/smartschool-tvet ]; then
    log "Removing Nginx TVET config..."
    rm -f /etc/nginx/sites-enabled/smartschool-tvet
fi

# Stop Nginx
if systemctl is-active nginx &>/dev/null; then
    log "Stopping Nginx..."
    systemctl stop nginx
fi

# Re-enable Apache
log "Re-enabling Apache..."
systemctl enable apache2
systemctl start apache2

if systemctl is-active apache2 &>/dev/null; then
    log "Apache is running."
else
    error "Apache failed to start!"
fi

log ""
log "Rollback complete. Old system should be accessible."
log "The TVET deployment files remain at ${NEW_APP_DIR} (not deleted)."
log "The new database (smart_school_tvet) is untouched."
