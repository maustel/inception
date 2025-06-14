#!/bin/bash

YEL='\033[0;33m'
RESET='\033[0m'

# set -e

# Create directories and set permissions
mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Check if database has been initialized already
if [ -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
	echo -e "${YEL}[--- Database already initialized. ---]${RESET}"
else
	# Check if the data directory is empty
	if [ -z "$(ls -A /var/lib/mysql)" ]; then
		echo -e "${YEL}[--- Initializing MariaDB database. ---]${RESET}"
		mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	fi

	# Start MariaDB temporarily to run SQL commands
	echo -e "${YEL}[--- Starting MariaDB temporarily to create database. ---]${RESET}"
	mysqld_safe --user=mysql --datadir=/var/lib/mysql & sleep 5

	# Create the WordPress database
	echo -e "${YEL}[--- Creating database $MYSQL_DATABASE. ---]${RESET}"
	mariadb -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
	CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
	CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
	GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
	ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
	FLUSH PRIVILEGES;
EOF

	# Stop the temporary MariaDB instance
	echo -e "${YEL}[--- Stopping temporary MariaDB. ---]${RESET}"
	mariadb-admin -uroot -p"$MYSQL_ROOT_PASSWORD" shutdown

	echo -e "${YEL}[--- MariaDB Initialization complete. ---]${RESET}"

fi

# Start new database process (exec) and start MariaDB in the foreground
echo -e "${YEL}[--- Starting MariaDB in the foreground. ---]${RESET}"
exec mariadbd --user=mysql

