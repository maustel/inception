#!/bin/bash

#https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/#download-and-configure-wordpress

YEL='\033[0;33m'
BLUE='\[\033[0;34m\]'
RESET='\033[0m'

echo -e "${YEL}[WP-SETUP-SCRIPT]${RESET}"

#print all commands in terminal
set -x


# -------------------[Wait for database] -----------
echo -e "${BLUE}[***Waiting for mariadb to be ready.***]${RESET}"
until mysqladmin ping -h mariadb --silent; do
    sleep 2
done

#------------------ [prerequisites] -----------------
#create necessary directories and give permissions
mkdir -p /run/php
chown www-data:www-data /run/php

# giving permission for php config file, overwriting existingphp config file with new config for listening on 0.0.0.0:9000
chmod +x /etc/php/7.4/fpm/pool.d/www.conf
chown -R www-data:www-data /etc/php/7.4/fpm/pool.d/www.conf

#install WP_CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#-------------------[Configure WordPress Directories] -----------

#create wp site's document root (for nginx)
mkdir -p ${WP_PATH}
#todo: put path in env

#change ownership to www-data user and group, because nginx runs with www-data user
chown -R www-data:www-data ${WP_PATH}

# DAVID: give permission for cache (solved all my issues)
mkdir -p /var/www/.wp-cli/cache
chown -R www-data:www-data /var/www/.wp-cli

cd ${WP_PATH}

#-------------------[Download and Configure WordPress] -----------

if wp core is-installed --allow-root > /dev/null 2>&1; then
	echo -e "${BLUE}[***WordPress is already installed***]${RESET}"
else
	#download wordpress
	su -s /bin/sh www-data  -c 'wp core download \
		--allow-root \
		--path="${WP_PATH}"'

	# configure (create config file wp-config.php)
	#TODO maybe only wp config create without su stuff
	su -s /bin/sh www-data -c 'wp config create \
		--path="$WP_PATH" \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$DB_HOST"\
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

	#-------------------[Run WordPress] -----------
	su -s /bin/sh www-data -c 'wp core install \
		--path="$WP_PATH" \
		--url=https://"$DOMAIN_NAME" \
		--title=inception \
		--admin_user="$WP_ADMIN" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--allow-root \
		--admin_email=amsel@rainbow.com \
		--skip-email'

	# Create regular user
	su -s /bin/sh www-data -c 'wp user create ${WP_USER} ${WP_USER}@${DOMAIN_NAME} \
			--user_pass=${WP_USER_PASSWORD} \
			--porcelain \
			--allow-root'
fi

# Set WordPress to listen on port 9000
# echo -e "${BLUE}[***Update PHP-FPM to listen on port 9000***]${RESET}"
# sed -i 's|^listen = .*|listen = 9000|' /etc/php/7.4/fpm/pool.d/www.conf

# Check if WordPress settings are correct
# echo -e "${BLUE}[***Validating PHP-FPM configuration***]${RESET}"
# php-fpm7.4 -t

#-------------------[Execute] -----------
echo "[END WP-SETUP-SCRIPT]"

#execute this program in foreground
exec php-fpm7.4 -F
