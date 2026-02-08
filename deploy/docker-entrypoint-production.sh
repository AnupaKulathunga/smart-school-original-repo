#!/bin/bash
set -e

# Create Docker-installed marker
echo "<?php define('DOCKER_INSTALLED', true);" > /var/www/html/smart_school_src/docker_installed.php

# Generate valid license for production URL
SITE_URL="${SITE_URL:-https://northlinkcollegelms.smartgov.co.za/}"
php /usr/local/bin/generate_license.php "$SITE_URL"

# Database config is baked in by deployment script — no need to generate

# Ensure temp and uploads are writable
mkdir -p /var/www/html/smart_school_src/temp
chmod 777 /var/www/html/smart_school_src/temp
chown -R www-data:www-data /var/www/html/smart_school_src/uploads 2>/dev/null || true
chown -R www-data:www-data /var/www/html/smart_school_src/application/logs 2>/dev/null || true

# Run database migrations (safe for re-runs due to IF NOT EXISTS checks)
echo "Running database migrations..."
MIGRATIONS_DIR="/var/www/html/smart_school_src/application/migrations"
if [ -d "$MIGRATIONS_DIR" ]; then
    for migration in "$MIGRATIONS_DIR"/*.sql; do
        if [ -f "$migration" ]; then
            echo "  Applying: $(basename $migration)"
            mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" --ssl-mode=REQUIRED 2>/dev/null < "$migration" || echo "  Warning: $(basename $migration) had errors (may be already applied)"
        fi
    done
    echo "Migrations complete."
fi

echo "Smart School TVET starting on $SITE_URL"

# Start Apache
exec docker-php-entrypoint apache2-foreground
