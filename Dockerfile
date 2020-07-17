FROM ubuntu:18.04

MAINTAINER Olivier RICARD <olivier+docker@talkspirit.com>

# Let the conatiner know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install software-properties-common wget zsh curl vim zsh git supervisor mongodb-clients -fy
# package
RUN apt-get install -y build-essential debhelper devscripts

RUN LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php -y -u && apt-get update

RUN apt-get update && apt-get install -y php7.4-fpm php7.4-mongodb php7.4-gd php7.4-curl php7.4-cli php7.4-soap php7.4-apcu php7.4-opcache php7.4-intl php7.4-mbstring php7.4-redis php7.4-dom php7.4-zip php7.4-geoip php7.4-imagick php-bcmath && \
echo "date.timezone=${PHP_TIMEZONE:-UTC}" > /etc/php/7.4/cli/conf.d/date_timezone.ini
#
#
## xdebug
#RUN apt-get install php7.4-xdebug
#RUN cd /etc/php/7.4/mods-available/;echo "xdebug.max_nesting_level = 200" >> xdebug.ini
#
### php-fpm config
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.4/cli/php.ini && \
    sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" /etc/php/7.4/cli/php.ini && \
    sed -i -e "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.4/fpm/php-fpm.conf && \
    sed -i -e "s/listen = \/run\/php\/php7.4-fpm.sock/;listen = \/run\/php\/php7.4-fpm.sock\nlisten = 0:9000/g" /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" /etc/php/7.4/cli/php.ini && \
    mkdir /run/php/

# tools
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer  && \
    curl -sS http://gordalina.github.io/cachetool/downloads/cachetool.phar -o /usr/local/bin/cachetool.phar && \
    curl -fLSs https://circle.ci/cli | bash
