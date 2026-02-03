FROM php:8.1-apache

# Install PHP extensions and mysql-client required by Smart School
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    default-mysql-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
        mysqli \
        pdo_mysql \
        gd \
        zip \
        intl \
        mbstring \
        fileinfo \
        curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set Apache document root to the smart_school_src directory
ENV APACHE_DOCUMENT_ROOT=/var/www/html/smart_school_src

# Update Apache config to use new document root and allow .htaccess
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf \
    && sed -ri -e 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# PHP configuration for development (live reload, no caching)
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" \
    && sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 64M/' "$PHP_INI_DIR/php.ini" \
    && sed -i 's/post_max_size = 8M/post_max_size = 64M/' "$PHP_INI_DIR/php.ini" \
    && sed -i 's/memory_limit = 128M/memory_limit = 256M/' "$PHP_INI_DIR/php.ini" \
    && echo "opcache.enable=0" >> "$PHP_INI_DIR/php.ini" \
    && echo "opcache.enable_cli=0" >> "$PHP_INI_DIR/php.ini" \
    && echo "display_errors=On" >> "$PHP_INI_DIR/php.ini" \
    && echo "error_reporting=E_ALL" >> "$PHP_INI_DIR/php.ini"

# Copy custom entrypoint and license generator
COPY docker/docker-entrypoint.sh /usr/local/bin/custom-entrypoint.sh
COPY docker/generate_license.php /usr/local/bin/generate_license.php
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# Set working directory
WORKDIR /var/www/html

# Set permissions for upload directories
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

ENTRYPOINT ["custom-entrypoint.sh"]