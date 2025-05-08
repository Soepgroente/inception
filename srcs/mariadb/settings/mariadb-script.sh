#!/bin/bash

# Put the configuration file in the right place, create necessary folders & set permissions

mv /mariadb.conf /etc/mysql/mariadb.conf.d/maria_conf.cnf
chmod 644 /etc/mysql/mariadb.conf.d/maria_conf.cnf

mkdir -p /run/mysqld
mkdir -p /var/log/mysql
mkdir -p /var/lib/mysql
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql /var/log/mysql
chown -R mysql:mysql /var/lib/mysql

# Pipes settings to mySQL initialisation

# Check required environment variables
if [[ -z "$MARIADB_DATABASE" || -z "$MARIADB_ROOT_PASSWORD" || -z "$MARIADB_USER" || -z "$MARIADB_USER_PASSWORD" ]]; then
  echo "Error: One or more required environment variables are missing."
  exit 1
fi

echo "Creating database"
{
	echo "FLUSH PRIVILEGES;"
	echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';"
	echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;"
	echo "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
	echo "CREATE USER IF NOT EXISTS root@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';"
	echo "CREATE USER IF NOT EXISTS $MARIADB_USER@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
	echo "GRANT ALL ON *.* TO $MARIADB_USER@'%' IDENTIFIED BY '$MARIADB_USER_PASSWORD';"
	echo "FLUSH PRIVILEGES;"
}	| mysqld --bootstrap

# Start actual database

echo "Starting MariaDB"
exec mysqld