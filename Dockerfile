FROM php:7.3-fpm-alpine

ENV COMPOSER_ALLOW_SUPERUSER 1

WORKDIR /app

COPY --from=composer /usr/bin/composer /usr/bin/composer

EXPOSE 9000

RUN set -xe && \
    mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini" && \
    apk update && \
    apk upgrade && \
    apk add -u --no-cache --virtual build-dependencies \
        $PHPIZE_DEPS \
        libpng \
        libjpeg-turbo && \
    \
    apk add -u --no-cache \
        libzip-dev \
        libjpeg-turbo-dev \
        libpng-dev && \
    \
    docker-php-ext-configure zip --with-libzip && \
    \
    docker-php-ext-configure gd --with-png-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
    \
    docker-php-ext-install -j$(nproc) \
        bcmath \
        exif \
        gd \
        opcache \
        pcntl \
        pdo_mysql \
        sockets \
        zip && \
    \
    pecl install redis && \
    docker-php-ext-enable redis && \
    \
    composer global require hirak/prestissimo -n && \
    \
    apk del -f --purge build-dependencies && \
    rm -rf /tmp/* /src /var/cache/apk/* /usr/src/* && \
    composer clearcache

COPY config/* $PHP_INI_DIR/conf.d/
