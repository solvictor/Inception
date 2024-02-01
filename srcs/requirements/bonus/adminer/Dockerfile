# On utilise l'avant derniere image de debian
FROM        debian:bullseye

# Cette image utilisera le port 8080 pour communiquer
EXPOSE      8080

# Mise a jour des packages et installation de php
RUN         apt update && apt install -y --no-install-recommends --no-install-suggests \
            wget \
            less \
            mariadb-client \
            php7.4 \
            php7.4-fpm \
            php7.4-mysql \
            php7.4-pdo \
            php7.4-common && \
            rm -rf /var/lib/apt/lists/*

# Installation de adminer
RUN \
            wget --no-check-certificate https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
            mkdir -p /var/www/inception && \
            mv ./adminer-4.8.1.php /var/www/inception/index.php

# Copie de notre fichier de configuration
COPY        /conf/www.conf /etc/php7.4/php-fpm.d/www.conf

# On lance adminer avec php
CMD         ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/inception"]