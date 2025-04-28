# At the time of setting this up, latest stable version of alpine is 3.21, penultimate version is 3.20
FROM alpine:3.20

# Set environment variables for MariaDB
ENV MYSQL_ROOT_PASSWORD=root_password \
    MYSQL_DATABASE=example_db \
    MYSQL_USER=example_user \
    MYSQL_PASSWORD=example_password

# Install MariaDB
RUN apk add --no-cache mariadb mariadb-client mariadb-server-utils

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Copy a default MariaDB configuration file if needed
COPY my.cnf /etc/mysql/my.cnf

# Expose the default MariaDB port
EXPOSE 3306

# Set the entrypoint to initialize MariaDB
ENTRYPOINT ["mysqld"]

# Default command to run when the container starts
CMD ["--user=mysql", "--console"]