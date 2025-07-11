#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
-keyout /etc/nginx/ssl/example.key \
-out /etc/nginx/ssl/example.crt \
-subj "/C=${CERT_COUNTRY:-US}/ST=${CERT_STATE:-CA}/L=${CERT_LOCALITY:-SF}/O=${CERT_ORG:-Company}/OU=${CERT_OU:-IT}/CN=${DOMAIN_NAME:-localhost}/emailAddress=${CERT_EMAIL:-admin@example.com}" 

mv /var/www/html/index.nginx-debian.html /var/www/html/index.html

nginx -g "daemon off;"