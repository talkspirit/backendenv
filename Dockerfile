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

RUN apt-get update && apt-get install -y mongodb-mongosh mongodb-org-tools php8.3-dev php8.3-fpm php8.3-mongodb php8.3-gd php8.3-curl php8.3-cli php8.3-soap php8.3-apcu php8.3-opcache php8.3-intl php8.3-mbstring php8.3-redis php8.3-dom php8.3-zip php8.3-imagick php8.3-bcmath php8.3-mysql && \
echo "date.timezone=${PHP_TIMEZONE:-Europe/Paris}" > /etc/php/8.3/cli/conf.d/date_timezone.ini && \
echo "date.timezone=${PHP_TIMEZONE:-Europe/Paris}" > /etc/php/8.3/fpm/conf.d/date_timezone.ini

RUN wget http://pear.php.net/go-pear.phar && php go-pear.phar
#RUN pecl install mongodb-1.16.2

# Install timecop
RUN mkdir -p /tmp/install && \
    git clone --depth 1 https://github.com/kiddivouchers/php-timecop.git /tmp/install/php-timecop && \
    cd /tmp/install/php-timecop && \
    git fetch origin 03a1ad366062d3adcd1efc39d69667debbc85ff5 && \
    git checkout 03a1ad366062d3adcd1efc39d69667debbc85ff5 && \
    phpize && \
    ./configure && \
    make && \
    make install  && \
    echo "extension=timecop.so" >> /etc/php/8.3/cli/php.ini

#
## xdebug
#RUN apt-get install php8.3-xdebug
#RUN cd /etc/php/8.3/mods-available/;echo "xdebug.max_nesting_level = 200" >> xdebug.ini
#
### php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/8.3/cli/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/8.3/cli/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/8.3/fpm/php-fpm.conf && \
    sed -i -e "s/listen = \/run\/php\/php8.3-fpm.sock/;listen = \/run\/php\/php8.3-fpm.sock\nlisten = 0:9000/g" /etc/php/8.3/fpm/pool.d/www.conf && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/8.3/cli/php.ini

# tools
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer  && \
    curl -sS http://gordalina.github.io/cachetool/downloads/cachetool.phar -o /usr/local/bin/cachetool.phar && \
    wget https://get.symfony.com/cli/installer -O - | bash && \
    mv /root/.symfony5/bin/symfony /usr/local/bin/symfony  && \
    curl -fLSs https://circle.ci/cli | bash
