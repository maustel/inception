#!/bin/bash

#https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/#download-and-configure-wordpress

YEL='\033[0;33m'
BLUE='\[\033[0;34m\]'
RESET='\033[0m'

echo -e "${YEL}[WP-SETUP-SCRIPT]${RESET}"

#------------------ [prerequisites] -----------------
echo -e "${BLUE}[***Doing preconfiguration.***]${RESET}"
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

#change ownership to www-data user and group, because nginx runs with www-data user
chown -R www-data:www-data ${WP_PATH}
chmod -R 755 ${WP_PATH}

#give permission for cache
mkdir -p /var/www/.wp-cli/cache
chown -R www-data:www-data /var/www/.wp-cli

cd ${WP_PATH}

#-------------------[Download and Configure WordPress] -----------

if wp core is-installed --allow-root > /dev/null 2>&1; then
	echo -e "${BLUE}[***WordPress is already installed***]${RESET}"
else
	echo -e "${BLUE}[***Downloading wordpress... ***]${RESET}"
	#------------[download wordpress] -----------
	wp core download \
		--allow-root \
		--path="${WP_PATH}"

	#-----------[configure (create config file wp-config.php)] ------
	echo -e "${BLUE}[***Creating config file wp-config.php... ***]${RESET}"
	wp config create \
		--path="$WP_PATH" \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$DB_HOST"\
		--dbprefix=wp_ \
		--allow-root

	#-------------------[Run WordPress] -----------
	echo -e "${BLUE}[***Installing worpress... ***]${RESET}"
	wp core install \
		--path="$WP_PATH" \
		--url=https://"$DOMAIN_NAME" \
		--title=Inception_42 \
		--admin_user="$WP_ADMIN" \
		--admin_password="$WP_ADMIN_PASSWORD" \
		--allow-root \
		--admin_email="$WP_ADMIN_MAIL" \
		--skip-email

	#-------------------[Create user] ------------------
	wp user create \
		"${WP_USER}" \
		"${WP_USER_MAIL}" \
		--user_pass="${WP_USER_PASSWORD}" \
		--role=author \
		--allow-root

	# Install Twenty Twentytwo theme
	echo -e "${BLUE}[***Install additional theme Twenty Twentytwo... ***]${RESET}"
	wp theme install twentytwentytwo \
		--activate \
		--allow-root
fi

#-------------------[Execute] -----------
echo -e "${BLUE}[***Wordpress is ready! ***]${RESET}"
#execute this program in foreground
exec php-fpm7.4 -F
