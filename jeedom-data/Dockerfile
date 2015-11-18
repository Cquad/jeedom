FROM debian:jessie

ENV JEEDOM_UPSTREAM_VERSION 1.212

RUN apt-get update && apt-get install -y \
	adduser \
	git \
	mysql-client \
	php5-cli \
	php5-curl \
	php5-mysql \
	unzip \
	wget

# installation nginx
RUN mkdir -p /usr/share/nginx/www

WORKDIR /usr/share/nginx/www/

# téléchargement de l'archive
#RUN wget --no-check-certificate -O jeedom.zip https://market.jeedom.fr/jeedom/stable/jeedom.zip && unzip jeedom.zip
RUN git clone https://github.com/jeedom/core.git jeedom && cd jeedom && git checkout ${JEEDOM_UPSTREAM_VERSION}

# ajout au préalable d'un dossier tmp
RUN mkdir -p /usr/share/nginx/www/jeedom/tmp

# définition des droits utilisateur/groupes/autres de manière récursif
RUN chmod 755 -R /usr/share/nginx/www/jeedom

# délégation des droits pour l'utilisateur www-data de manière récursif
RUN chown -R www-data:www-data /usr/share/nginx/www/jeedom

# ajout de l'utilisateur www-data au group dialout (pour piloter la connexion 3G éventuelle)
RUN adduser www-data dialout

# on copie le fichier de configuration d'exemple 
RUN cp /usr/share/nginx/www/jeedom/core/config/common.config.sample.php /usr/share/nginx/www/jeedom/core/config/common.config.php

VOLUME /usr/share/nginx/www/jeedom/

COPY docker-entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]



