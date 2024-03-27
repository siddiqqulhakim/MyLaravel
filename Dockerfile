# Use the php:apache image as the base
FROM php:apache

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
    && docker-php-ext-install gd pdo_pgsql curl
ENV TZ="Asia/Jakarta"

RUN echo "extension=gd" >> /usr/local/etc/php/conf.d/docker-php-ext-sodium.ini

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory in the container
WORKDIR /var/www/html

# Copy the entire project directory to the container
COPY . .

# Install project dependencies
RUN composer install --ignore-platform-req=ext-zip --ignore-platform-reqs

# Expose port 80 for the Apache server
EXPOSE 80

# Start Apache when the container starts
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]