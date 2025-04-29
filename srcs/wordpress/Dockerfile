FROM debian:bullseye

RUN apt-get update -y && \
	apt-get -y install wget curl bash php7.4 php-mysql php-fpm mariadb-client

RUN mkdir -p /run/php

COPY /settings/www.conf /etc/php/7.4/fpm/pool.d
COPY /settings/entrypoint.sh /

RUN chmod +x /entrypoint.sh

EXPOSE 9000

CMD ["/entrypoint.sh"]