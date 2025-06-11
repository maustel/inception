#!/bin/bash

#https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/#download-and-configure-wordpress

echo "[WP-SETUP-SCRIPT]"

#print all commands in terminal
set -x

#------------------ [prerequisites] -----------------
#create necessary directories and give permissions
mkdir -p /run/php
chown www-data:www-data /run/php

# # giving permission for php config file, overwriting existingphp config file with new config for listening on 0.0.0.0:9000
# chmod +x /www.conf
# mv -f www.conf /etc/php/7.4/fpm/pool.d/


#install WP_CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#-------------------[Configure WordPress Dixectories] -----------

#create wp site's document root (for nginx)
mkdir -p /var/www/html/maustel.42.fr/public_html
#todo: put path in env

#change ownership to www-data user and group, because nginx runs with www-data user
chown -R www-data:www-data /var/www/html/maustel.42.fr/public_html

# DAVID: give permission for cache (solved all my issues)
mkdir -p /var/www/.wp-cli/cache
chown -R www-data:www-data /var/www/.wp-cli

cd /var/www/html/maustel.42.fr/public_html

#-------------------[Download and Configure WordPress] -----------


#download wordpress
su -s /bin/sh www-data  -c 'wp core download --allow-root --path="/var/www/html/maustel.42.fr/public_html"'

# configure
su -s /bin/sh www-data -c 'wp config create --path="/var/www/html/maustel.42.fr/public_html" \
	--dbname=wordpress \
	--dbuser=wpuser \
	--dbpass=password \
	--dbhost=localhost \
	--dbprefix=wp_ \
	--allow-root'

# configure
# wp core config \
# 	--dbname=wp \
# 	--dbuser=wp_user \
# 	--dbpass=pw \
# 	--dbhost=localhost \
# 	--dbprefix=wp_ \
# 	--allow-root

# -------------------[Wait for databse] -----------
# wait for mariadb
# todo
# until wp db check --allow-root; do
# 	sleep 5
# done

#-------------------[Run WordPress] -----------
su -s /bin/sh www-data -c "wp core install \
    --path=/var/www/html/maustel.42.fr/public_html \
    --url=https://maustel.42.fr \
    --title=inception \
    --admin_user=admin \
    --admin_password=pw \
    --allow-root \
    --admin_email=amsel@rainbow.com \
	--skip-email"

## Error: 'wp-config.php' not found.


#-------------------[Execute] -----------
echo "[END WP-SETUP-SCRIPT]"

#execute this program in foreground
exec php-fpm7.4 -F
