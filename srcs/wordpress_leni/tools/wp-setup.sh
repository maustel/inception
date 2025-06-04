#!/bin/bash

#https://www.linode.com/docs/guides/how-to-install-wordpress-using-wp-cli-on-debian-10/#download-and-configure-wordpress

#wait for mariadb
#todo

#print all commands in terminal
set -x

#------------------ [prerequisites] -----------------

#install WP_CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

#Download and Configure WordPress


