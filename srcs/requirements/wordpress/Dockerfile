# the RUN sed changes the php.ini file to fix the path info
# RUN wget downloads the wp-cli.phar file that is used to install wordpress through the command line
# at the end creates the folders and set the permissions to the www-data user
# the runs the setup.sh script that is used to install wordpress
# and start the php-fpm8.2 server in the foreground

# On utilise la derniere image de debian
FROM	debian:bookworm

# Cette image utilisera le port 9000 pour communiquer
EXPOSE	9000

# Definition des arguments pour le chemin vers PHP-FPM
ARG		PHPPATH=/etc/php/8.2/fpm

# Mise a jour des packages et installation de PHP et de certaines dependances
RUN		apt update && apt install --no-install-recommends --no-install-suggests -y \
		ca-certificates \
		php8.2-fpm \
		php8.2-mysql \
		wget \
		tar && \
		rm -rf /var/lib/apt/lists/*

# Arret du service php8.2-fpm (si jamais il s'executais)
RUN		service php8.2-fpm stop

# Copie de la configuration PHP-FPM personnalisee
COPY	conf/www.conf ${PHPPATH}/pool.d/

# Modification de la configuration PHP-FPM pour ajuster certains parametres
RUN		sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${PHPPATH}/php.ini && \
		sed -i "s/listen = \/run\/php\/php$PHP_VERSION_ENV-fpm.sock/listen = 9000/g" ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;listen.mode = 0660/listen.mode = 0660/g' ${PHPPATH}/pool.d/www.conf && \
		sed -i 's/;daemonize = yes/daemonize = no/g' ${PHPPATH}/pool.d/www.conf

# Installation de WP-CLI (outil en ligne de commande pour installer WordPress)
RUN		wget --no-check-certificate https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
		chmod +x wp-cli.phar && \
		mv wp-cli.phar /usr/local/bin/wp

# Creation des repertoires necessaires
RUN		mkdir -p /run/php/ && \
		mkdir -p /var/run/php/ && \
		mkdir -p /var/www/inception/

# Mise a jour des permissions de l'arborescence du site
RUN		chown -R www-data:www-data /var/www/inception/

# Copie de la configuration WP-Config
COPY	conf/wp-config.php /tmp/

# Copie du script de configuration
COPY	tools/setup.sh /bin/
RUN		chmod +x /bin/setup.sh

# Execution du script de configuration
CMD		["setup.sh", "php-fpm8.2", "--nodaemonize"]