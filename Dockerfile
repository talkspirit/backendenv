FROM ubuntu:20.04

LABEL "com.talkspirit.maintainer" "Olivier RICARD <olivier+docker@talkspirit.com>"

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential debhelper devscripts cron software-properties-common wget zsh curl vim zsh git supervisor -y

# MongoDB shell tools
RUN wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-6.0.list
RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y -u && apt-get update

# geoip https://github.com/maxmind/GeoIP2-php

RUN apt-get update && apt-get install -y mongodb-mongosh mongodb-org-tools php8.1-fpm php8.1-mongodb php8.1-gd php8.1-curl php8.1-cli php8.1-soap php8.1-apcu php8.1-opcache php8.1-intl php8.1-mbstring php8.1-redis php8.1-dom php8.1-zip php8.1-imagick php8.1-bcmath php8.1-mysql && \
echo "date.timezone=${PHP_TIMEZONE:-Europe/Paris}" > /etc/php/8.1/cli/conf.d/date_timezone.ini && \
echo "date.timezone=${PHP_TIMEZONE:-Europe/Paris}" > /etc/php/8.1/fpm/conf.d/date_timezone.ini

#
#
## xdebug
#RUN apt-get install php8.1-xdebug
#RUN cd /etc/php/8.1/mods-available/;echo "xdebug.max_nesting_level = 200" >> xdebug.ini
#
### php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/8.1/cli/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/8.1/cli/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/8.1/fpm/php-fpm.conf && \
    sed -i -e "s/listen = \/run\/php\/php8.1-fpm.sock/;listen = \/run\/php\/php8.1-fpm.sock\nlisten = 0:9000/g" /etc/php/8.1/fpm/pool.d/www.conf && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/8.1/cli/php.ini && \
    mkdir /run/php/

# tools
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer  && \
    curl -sS http://gordalina.github.io/cachetool/downloads/cachetool.phar -o /usr/local/bin/cachetool.phar && \
    wget https://get.symfony.com/cli/installer -O - | bash && \
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony  && \
    curl -fLSs https://circle.ci/cli | bash
