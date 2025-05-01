# At the time of setting this up, latest stable version of alpine is 3.21, penultimate version is 3.20
FROM alpine:3.20

RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils

# Creates database folder and gives ownership to mariaDB

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy the settings & script to the image and set permissions for the script to be executable

COPY ./settings/mariadb.conf /
COPY ./settings/mariadb-script.sh /

RUN chmod +x /mariadb-script.sh

EXPOSE 3306

CMD ["/mariadb-script.sh"]