FROM redis:5-alpine3.13 AS redis
FROM alpine:3.13

WORKDIR /var/www

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/launch.sh"]

RUN apk add --no-cache \
        bash \
        bash-completion \
        ca-certificates \
        curl \
        findutils \
        git \
        git-bash-completion \
        git-subtree \
        msmtp \
        nano \
        openssh \
        openssh-sftp-server \
        patch \
        py3-pip \
        sudo \
        supervisor \
        shadow \
        tar \
        unzip \
        wget

ENV PHP_VERSION=7.4 \
    ENABLE_REDIS=Off \
    ENABLE_CRON=Off \
    ENABLE_SSH=Off \
    ENABLE_DEV=Off \
    NGINX_CONF=default \
    NGINX_PORT=80 \
    PHP_DISPLAY_ERRORS=Off \
    PHP_OPCACHE_VALIDATE=On \
    PHP_MAX_CHILDREN=30 \
    PHP_TIMEZONE=Europe/Lisbon \
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
        php7=~${PHP_VERSION} \
            php7-bcmath \
            php7-ctype \
            php7-curl \
            php7-dom \
            php7-fileinfo \
            php7-fpm \
            php7-iconv \
            php7-gd \
            php7-intl \
            php7-mbstring \
            php7-mysqli \
            php7-mysqlnd \
            php7-opcache \
            php7-openssl \
            php7-pcntl \
            php7-pdo_mysql \
            php7-pecl-mcrypt \            
            php7-pecl-redis \
            php7-pecl-xdebug \
            php7-simplexml \
            php7-soap \
            php7-sockets \
            php7-sodium \
            php7-tokenizer \
            php7-xml \
            php7-xmlreader \
            php7-xmlwriter \
            php7-xsl \
            php7-zip \
        composer \
        nginx \
        nodejs \
        npm \
        yarn && \
    npm install gulp-cli -g && \
    npm cache clean --force && \
    rm -Rf /var/www/*

COPY . /

RUN /build.sh

COPY --from=redis /usr/local/bin/redis-* /usr/local/bin/

USER edge

EXPOSE $NGINX_PORT
