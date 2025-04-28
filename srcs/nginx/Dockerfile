# At the time of setting this up, latest stable version of debian is bookworm, penultimate version is bullseye

FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y nginx openssl -y

RUN mkdir -p /etc/nginx/ssl && chmod 700 /etc/nginx/ssl

COPY ./settings/nginx-config.conf /etc/nginx/conf.d/default.conf
COPY ./settings/nginx-script.sh /

RUN chmod +x /nginx-script.sh

EXPOSE 443

CMD ["/nginx-script.sh"]