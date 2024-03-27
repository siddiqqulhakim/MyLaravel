#!/bin/bash
php artisan config:cache
php artisan route:cache
/usr/sbin/apache2ctl -D FOREGROUND
exec "$@"
