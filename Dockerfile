FROM armv7/armhf-ubuntu:14.04
MAINTAINER "Alberto Muratore" <muratore.alberto85@gmail.com>
ENV REFRESHED_AT 2016-09-21

RUN apt-get -yqq update 
RUN apt-get -yqq install apache2 mariadb-server libapache2-mod-php5 php5-gd php5-json php5-mysql php5-curl php5-intl php5-mcrypt php5-imagick

VOLUME /var/www/nextcloud/data
VOLUME /var/www/nextcloud/config
VOLUME /var/www/nextcloud/apps2
VOLUME /var/log/apache2

WORKDIR /var/www/nextcloud

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

EXPOSE 80 443

ENTRYPOINT [ "/usr/sbin/apache2" ]
CMD ["-D", "FOREGROUND" ]
