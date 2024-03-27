#!/bin/bash
# Stop on any error
set -e

# Check if the vendor directory exists
if [ ! -d "vendor" ]; then
    echo "Vendor directory not found. Installing Composer dependencies..."
    # Install Composer dependencies
    composer install --no-dev --optimize-autoloader
fi

# Running Laravel optimizations
# It's important to run these after `composer install` to ensure all dependencies are available
php artisan config:cache
php artisan route:cache

# Ensure Apache runs in the foreground
exec /usr/sbin/apache2ctl -D FOREGROUND
