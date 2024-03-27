#!/bin/bash
# Stop on any error
set -e

# Running Laravel optimizations
php artisan config:cache
php artisan route:cache

# Ensure Apache runs in the foreground
exec /usr/sbin/apache2ctl -D FOREGROUND
