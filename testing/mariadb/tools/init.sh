#!/bin/bash

# Exit immediately on error
set -e

# Check if the data directory is empty
if [ -z "$(ls -A /var/lib/mysql)" ]; then
	echo "Data directory is empty. Initializing MariaDB database..."
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MariaDB temporarily to run SQL commands
echo "Starting MariaDB temporarily..."
mysqld_safe --user=mysql --datadir=/var/lib/mysql &
sleep 5

# Create the WordPress database
echo "Creating database $MYSQL_DATABASE..."
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
EOF

# Stop the temporary MariaDB instance
echo "Stopping temporary MariaDB instance..."
mysqladmin -uroot -p"$MYSQL_ROOT_PASSWORD" shutdown

echo "MariaDB Initialization complete."
