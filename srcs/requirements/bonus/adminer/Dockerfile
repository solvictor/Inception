FROM        debian:bookworm

EXPOSE      8000

RUN         apt update && apt install -y --no-install-recommends --no-install-suggests \
            wget \
            less \
            mariadb-client \
            php8.2 \
            php8.2-fpm \
            php8.2-common && \
            rm -rf /var/lib/apt/lists/*

#RUN the adminer part, create html directory, move the adminer directory and add user

RUN \
            wget --no-check-certificate https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php && \
            mkdir -p /var/www/inception && \
            mv ./adminer-4.8.1.php /var/www/inception/index.php

COPY        /conf/www.conf /etc/php8.2/php-fpm.d/www.conf

STOPSIGNAL  SIGQUIT

CMD         ["php-fpm8.2", "--nodaemonize"]