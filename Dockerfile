# Use the php:apache image as the base
FROM php:apache

# Set environment variable
ENV TZ="Asia/Jakarta"

# Install additional PHP extensions and required packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    zlib1g-dev \
    libpq-dev \
    libcurl4-openssl-dev \
    zip \
    unzip \
    p7zip-full \
    git \
    tzdata \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install gd pdo_pgsql curl

# Use the production version of php.ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the entire project directory to the container
COPY . .

# Install project dependencies, ignoring platform reqs for zip
RUN composer install --no-scripts --no-dev --optimize-autoloader

# Expose port 80 for the Apache server
EXPOSE 80

# Start Apache when the container starts
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
