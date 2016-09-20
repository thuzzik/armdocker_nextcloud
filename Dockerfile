FROM armv7/armhf-ubuntu:14.04
MAINTAINER "Alberto Muratore" <muratore.alberto85@gmail.com>
ENV REFRESHED_AT 2016-09-21
ARG NEXTCLOUD_VERSION=10.0.0

RUN apt-get -yqq update 
RUN apt-get -yqq install apache2 mariadb-server libapache2-mod-php5 php5-gd php5-json php5-mysql php5-curl php5-intl php5-mcrypt php5-imagick
RUN mkdir -v /var/www/nextcloud \
&& cd /var/www/nextcloud \
&& NEXTCLOUD_TARBALL="nextcloud-${NEXTCLOUD_VERSION}.tar.bz2" \
&& wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL} \
&& wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL}.sha256 \
&& wget -q https://download.nextcloud.com/server/releases/${NEXTCLOUD_TARBALL}.asc \
&& wget -q https://nextcloud.com/nextcloud.asc \
&& echo "Verifying both integrity and authenticity of ${NEXTCLOUD_TARBALL}..." \
&& CHECKSUM_STATE=$(echo -n $(sha256sum -c ${NEXTCLOUD_TARBALL}.sha256) | tail -c 2) \
&& if [ "${CHECKSUM_STATE}" != "OK" ]; then echo "Warning! Checksum does not match!" && exit 1; fi \
&& gpg --import nextcloud.asc \
&& FINGERPRINT="$(LANG=C gpg --verify ${NEXTCLOUD_TARBALL}.asc ${NEXTCLOUD_TARBALL} 2>&1 \
| sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
&& if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
&& if [ "${FINGERPRINT}" != "${GPG_nextcloud}" ]; then echo "Warning! Wrong GPG fingerprint!" && exit 1; fi \
&& echo "All seems good, now unpacking ${NEXTCLOUD_TARBALL}..." \
&& tar xjf ${NEXTCLOUD_TARBALL} --strip 1 -C /var/www/nextcloud 

COPY ./scripts/nextcloud.conf /etc/apache2/sites-available/nextcloud.conf

RUN a2ensite nextcloud.conf \
&& a2enmod rewrite \
&& a2enmod headers \
&& a2enmod env \
&& a2enmod dir \
&& a2enmod mime \
&& chown -R www-data:www-data /var/www/nextcloud/ \
&& service apache2 restart 

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
