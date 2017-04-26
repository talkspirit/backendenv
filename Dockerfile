FROM ubuntu:16.04

MAINTAINER Olivier RICARD <olivier+docker@talkspirit.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install software-properties-common wget zsh curl vim zsh git supervisor -y
# package
RUN apt-get install -y build-essential debhelper devscripts

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y -u && apt-get update

RUN apt-get update && apt-get install -y php7.1-fpm php7.1-mongodb php7.1-gd php7.1-curl php7.1-cli php7.1-soap php7.1-apcu php7.1-opcache php7.1-intl php7.1-mbstring php7.1-redis php7.1-dom

## Time Zone
RUN echo "date.timezone=${PHP_TIMEZONE:-UTC}" > /etc/php/7.1/cli/conf.d/date_timezone.ini
#
#
## xdebug
#RUN apt-get install php7.1-xdebug
#RUN cd /etc/php/7.1/mods-available/;echo "xdebug.max_nesting_level = 200" >> xdebug.ini
#
### php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.1/cli/php.ini
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.1/cli/php.ini
RUN sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.1/fpm/php-fpm.conf
RUN sed -i -e "s/listen = \/run\/php\/php7.1-fpm.sock/;listen = \/run\/php\/php7.1-fpm.sock\nlisten = 0:9000/g" /etc/php/7.1/fpm/pool.d/www.conf
#
### cli config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.1/cli/php.ini

# tools
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -sS http://gordalina.github.io/cachetool/downloads/cachetool.phar -o /usr/local/bin/cachetool.phar
