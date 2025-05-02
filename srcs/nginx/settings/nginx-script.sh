#!/bin/bash

echo "Creating a self-signed SSL certificate..."
openssl req \
    -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -subj "/C=NL/ST=Holland/L=Amsterdam/O=Codam/CN=${DOMAIN_NAME}" \
    -out "/etc/nginx/ssl/selfsigned.crt" \
    -keyout "/etc/nginx/ssl/selfsigned.key"

echo "Starting nginx..."
exec nginx -g "daemon off;"