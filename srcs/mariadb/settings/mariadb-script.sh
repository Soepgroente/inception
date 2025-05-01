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

echo "Creating database"
{
	echo "FLUSH PRIVILEGES;"
	echo "DROP USER 'root'@'localhost';"
	echo "CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE;"
	echo "CREATE USER IF NOT EXISTS root@'%' IDENTIFIED BY '$MARIADB_ROOT_PASSWORD';"
	echo "CREATE USER IF NOT EXISTS $MARIADB_USER@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
	echo "GRANT ALL ON *.* TO $MARIADB_USER@'%' IDENTIFIED BY '$MARIADB_PASSWORD';"
	echo "FLUSH PRIVILEGES;"
}	| mysqld --bootstrap

# Start actual database

echo "Starting MariaDB"
exec mysqld