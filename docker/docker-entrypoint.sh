#!/bin/bash
set -e

# Create a PHP config to mark as Docker-installed
echo "<?php define('DOCKER_INSTALLED', true);" > /var/www/html/smart_school_src/docker_installed.php

# Generate valid license for Docker base URL
php /usr/local/bin/generate_license.php "http://localhost:8080/"

# Create database.php if it doesn't exist (gitignored file)
DB_CONFIG="/var/www/html/smart_school_src/application/config/database.php"
if [ ! -f "$DB_CONFIG" ]; then
    echo "Creating database.php for Docker environment..."
    cat > "$DB_CONFIG" <<'DBEOF'
<?php
defined('BASEPATH') OR exit('No direct script access allowed');

$active_group = 'default';
$query_builder = TRUE;

$db['default'] = array(
    'dsn' => '',
    'hostname' => 'db',
    'username' => 'smartschool',
    'password' => 'smartschool123',
    'database' => 'smart_school',
    'dbdriver' => 'mysqli',
    'dbprefix' => '',
    'pconnect' => FALSE,
    'db_debug' => TRUE,
    'cache_on' => FALSE,
    'cachedir' => '',
    'char_set' => 'utf8',
    'dbcollat' => 'utf8_general_ci',
    'swap_pre' => '',
    'encrypt' => FALSE,
    'compress' => FALSE,
    'stricton' => FALSE,
    'failover' => array(),
    'save_queries' => TRUE
);
DBEOF
fi

# Ensure temp and uploads are writable
mkdir -p /var/www/html/smart_school_src/temp
chmod 777 /var/www/html/smart_school_src/temp
chown -R www-data:www-data /var/www/html/smart_school_src/uploads 2>/dev/null || true

# Run database migrations (safe for re-runs due to IF NOT EXISTS checks)
echo "Running database migrations..."
MIGRATIONS_DIR="/var/www/html/smart_school_src/application/migrations"
if [ -d "$MIGRATIONS_DIR" ]; then
    for migration in "$MIGRATIONS_DIR"/*.sql; do
        if [ -f "$migration" ]; then
            echo "  Applying: $(basename $migration)"
            mysql -h db -u smartschool -psmartschool123 smart_school 2>/dev/null < "$migration" || echo "  Warning: $(basename $migration) had errors (may be already applied)"
        fi
    done
    echo "Migrations complete."
fi

# Start Apache
exec docker-php-entrypoint apache2-foreground
