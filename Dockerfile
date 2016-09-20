FROM armv7/armhf-ubuntu:14.04
MAINTAINER "Alberto Muratore"

RUN apt-get -yqq update && apt-get -yqq install apache2 \
                                         mariadb-server \
                                         libapache2-mod-php5 \
                                         php5-gd \
                                        php5-json \
                                        php5-mysql \
                                        php5-curl \
                                        php5-intl \
                                        php5-mcrypt \
                                        php5-imagick \
