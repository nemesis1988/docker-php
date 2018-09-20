FROM php:7.2-fpm

MAINTAINER nemesis1988

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        libmemcached-dev \
        libz-dev \
        libjpeg-dev \
        libfreetype6-dev \
        libssl-dev \
        git \
        mysql-client \
        libssl-dev \
        libc-client2007e-dev \
        libkrb5-dev \
        libmcrypt-dev

# Install the PHP mcrypt extention
#RUN docker-php-ext-install mcrypt

# Install the PHP pdo_mysql extention
RUN docker-php-ext-install pdo_mysql

RUN docker-php-ext-configure imap --with-imap-ssl --with-kerberos \
        && docker-php-ext-install imap \
        && docker-php-ext-install opcache

RUN pecl install mcrypt-1.0.1

RUN echo "extension=mcrypt.so" > /usr/local/etc/php/conf.d/mcrypt.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

#####################################
# Set Timezone
#####################################

ARG TZ=UTC
ENV TZ ${TZ}
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN composer global require "hirak/prestissimo:^0.3"
RUN composer global require "fxp/composer-asset-plugin" --no-plugins