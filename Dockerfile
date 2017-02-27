FROM ubuntu:16.04

MAINTAINER Olivier RICARD <olivier+docker@talkspirit.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y php7.0-fpm php7.0-dev php7.0-cli wget zsh curl vim zsh git supervisor

## Basic Requirements
RUN apt-get -y install php7.0-curl php7.0-soap php-apcu php7.0-gd php7.0-opcache php-mongodb php7.0-intl php7.0-mbstring php-redis php-xdebug

# Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > /etc/php/7.0/cli/conf.d/date_timezone.ini

# add extension
RUN phpenmod redis

# xdebug
RUN cd /etc/php/7.0/mods-available/;echo "xdebug.max_nesting_level = 200" >> xdebug.ini

## php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/cli/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.0/cli/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.0/fpm/php-fpm.conf
RUN sed -i -e "s/listen = \/run\/php\/php7.0-fpm.sock/;listen = \/run\/php\/php7.0-fpm.sock\nlisten = 0:9000/g" /etc/php/7.0/fpm/pool.d/www.conf

## cli config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.0/cli/php.ini

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
