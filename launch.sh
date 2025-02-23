#!/bin/bash

export USER=$(id -u -n)

if [[ $ENABLE_DEV = "On" ]]; then
    sudo chown -R $USER:$USER /var/log/php7
else
    sudo chmod g=r /etc/passwd
fi

# Set SSH password
if [[ $ENABLE_SSH = "On" ]]; then
    echo "edge:$SSH_PASSWORD" | sudo chpasswd
fi

# Load custom environment variables from .env
if [[ -f "$WEB_ROOT/.env" ]]; then
    export $(grep -v '^#' $WEB_ROOT/.env | xargs -d '\n')
fi

env | sudo dd status=none of=/etc/environment

sudo chmod -f 644 /etc/crontabs/*

j2 /templates/nginx.conf.j2 | sudo dd status=none of=/etc/nginx/nginx.conf
j2 /templates/nginx-${NGINX_CONF}.conf.j2 | sudo dd status=none of=/etc/nginx/conf.d/${NGINX_CONF}.conf
j2 /templates/supervisord.conf.j2 | sudo dd status=none of=/etc/supervisord.conf
j2 /templates/php-fpm.conf.j2 | sudo dd status=none of=/etc/php7/php-fpm.conf
j2 /templates/xdebug.ini.j2 | sudo dd status=none of=/etc/php7/conf.d/xdebug.ini
j2 /templates/msmtprc.j2 | sudo dd status=none of=/etc/msmtprc

chmod o+w /dev/stdout

sudo /usr/bin/supervisord