FROM php:7.4-fpm-bullseye

RUN apt-get update \
    && apt-get -y install \ 
    software-properties-common

RUN add-apt-repository ppa:ondrej/php

RUN apt-get -y install --no-install-recommends --no-install-suggests \
    zip \
    git \
    libzip-dev \
    libxml2-dev \
    && printf "no\n" \
    | pecl install xdebug-3.1.0 \
    && docker-php-ext-install -j$(nproc) \
    pdo_mysql \
    zip \
    && docker-php-ext-enable xdebug 

RUN pecl channel-update pecl.php.net

RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

COPY ./php/php.ini /usr/local/etc/php/php.ini

COPY ./php/99-xdebug.ini "${PHP_INI_DIR}/conf.d"