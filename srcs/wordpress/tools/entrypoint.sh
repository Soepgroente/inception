#!/bin/bash

mkdir -p /var/www/html/wordpress
# touch /run/php/php7.4-fpm.pid;

if [ ! -f wp-config.php ]; then

	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp
    
    cd /var/www/html/wordpress
    
   	wp core download \
        --path="${WP_ROOT_FOLDER}" \
        --allow-root
    echo "WordPress downloaded."

    echo "Waiting for MariaDB to connect..."
    until mysqladmin -h${WP_DATABASE_HOST} -u${MARIADB_USER} -p${MARIADB_USER_PASSWORD} ping; do
        sleep 1
    done

   	echo "Creating WordPress Configuration..."
	wp config create \
        --path="${WP_ROOT_FOLDER}" \
		--dbname="${WP_DATABASE_NAME}" \
		--dbuser="${MARIADB_USER}" \
		--dbpass="${MARIADB_USER_PASSWORD}" \
		--dbhost="${WP_DATABASE_HOST}" \
		--allow-root

	echo "Creating Wordpress Admin..."
    wp core install \
        --path="${WP_ROOT_FOLDER}" \
        --url="${DOMAIN_NAME}" \
        --title="inslaption" \
        --admin_user="${WP_ADMIN}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --allow-root

    echo "Creating Wordpress User..." 
	wp user create ${WP_USER} ${WP_USER_EMAIL} \
        --path="${WP_ROOT_FOLDER}" \
        --user_pass="${WP_USER_PASSWORD}" \
		--role=editor \
       	--allow-root

    echo "WordPress setup complete."
else
    echo "WordPress is already setup."
fi

# Change permissions at the end to also affect newly created folders

chown -R www-data:www-data /var/www/*;
chmod -R 755 /var/www/*;

echo "Starting PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F