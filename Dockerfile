FROM ubuntu:15.04

MAINTAINER Olivier RICARD <olivier.docker@talkspirit.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update

RUN apt-get install -y php5-fpm php5-dev php5-cli wget zsh curl vim zsh

## Basic Requirements
RUN apt-get -y install php5-curl php5-apcu php5-dbg php5-gd php5-imagick php5-intl php5-json php5-mcrypt php5-redis php5-xdebug php5-xmlrpc

#
## Install extensions
RUN pecl install mongo


RUN echo "extension=mongo.so" > /etc/php5/mods-available/mongo.ini

RUN cd /etc/php5/fpm/conf.d;ln -s ../../mods-available/mongo.ini 020-mongo.ini
RUN cd /etc/php5/cli/conf.d;ln -s ../../mods-available/mongo.ini 020-mongo.ini
RUN cd/etc/php5/mods-available/;echo "xdebug.max_nesting_level = 200" >> xdebug.ini
##
## php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php5/fpm/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf
RUN sed -i -e "s/listen = \/var\/run\/php5-fpm.sock/;listen = \/var\/run\/php5-fpm.sock\nlisten = 0:9000/g" /etc/php5/fpm/pool.d/www.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
