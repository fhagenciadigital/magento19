#!/bin/bash

export USER=$(id -u -n)

sudo chmod g=r /etc/passwd

# Load custom environment variables from .env
if [[ -f "$WEB_ROOT/.env" ]]; then
    export $(grep -v '^#' $WEB_ROOT/.env | xargs -d '\n')
fi

env | sudo dd status=none of=/etc/environment

sudo chmod -f 644 /etc/crontabs/*
sudo mkdir -p /etc/nginx/conf.d

j2 /templates/nginx.conf.j2 | sudo dd status=none of=/etc/nginx/nginx.conf
j2 /templates/nginx-${NGINX_CONF}.conf.j2 | sudo dd status=none of=/etc/nginx/conf.d/${NGINX_CONF}.conf
j2 /templates/supervisord.conf.j2 | sudo dd status=none of=/etc/supervisord.conf
j2 /templates/php-fpm.conf.j2 | sudo dd status=none of=/etc/php7/php-fpm.conf
j2 /templates/msmtprc.j2 | sudo dd status=none of=/etc/msmtprc

chmod o+w /dev/stdout

sudo /usr/bin/supervisord -c /etc/supervisord.conf