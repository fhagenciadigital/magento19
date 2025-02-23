FROM alpine:3.15

WORKDIR /var/www

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/launch.sh"]

RUN apk update && apk add --no-cache \
	bash \
	supervisor \
	tzdata \
	gettext \
    sudo \
    py3-pip \
	curl

ENV PHP_VERSION=7.4 \
    ENABLE_CRON=On \
    ENABLE_SSH=Off \
    ENABLE_DEV=Off \
    NGINX_CONF=default \
    NGINX_PORT=80 \
    PHP_MAX_CHILDREN=30 \
    PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true \
    WEB_ROOT=/var/www \
    COMPOSER_MEMORY_LIMIT=-1 \
    COMPOSER_PROCESS_TIMEOUT=600 \
    XDEBUG_ENABLE=Off \
    XDEBUG_HOST= \
    SMTP_HOST=smtp.mailtrap.io \
    SMTP_PORT=25 \
    SMTP_USER= \
    SMTP_PASS= \
    SMTP_FROM=

RUN apk add --no-cache \
    php7=~${PHP_VERSION}

RUN apk add --no-cache \        
        php7-curl \
        php7-dom \     
        php7-fileinfo \
        php7-fpm \
        php7-gd \
        php7-gettext \
        php7-json \
        php7-mbstring \
        php7-openssl \
        php7-pdo \
        php7-phar \
        php7-psr \
        php7-opcache \
        php7-session \
        php7-simplexml \
        php7-tokenizer \
        php7-xml \
        php7-zlib \
        php7-cli \
        php7-pdo_mysql \
        php7-iconv \
        php7-pecl-mcrypt

RUN apk add --no-cache \        
        nginx \
        rm -Rf /var/www/*

COPY . /

RUN /build.sh

USER edge

EXPOSE $NGINX_PORT
