#!/bin/bash
set -e

# Create a PHP config to mark as Docker-installed
echo "<?php define('DOCKER_INSTALLED', true);" > /var/www/html/smart_school_src/docker_installed.php

# Ensure temp and uploads are writable
mkdir -p /var/www/html/smart_school_src/temp
chmod 777 /var/www/html/smart_school_src/temp
chown -R www-data:www-data /var/www/html/smart_school_src/uploads 2>/dev/null || true

# Start Apache
exec docker-php-entrypoint apache2-foreground
