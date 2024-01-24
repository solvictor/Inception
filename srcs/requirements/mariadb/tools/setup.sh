#!/bin/bash

# On demarre mariadb
service mariadb start

# On cree la base de donne et un utilisateur
# On donne acces a l'utilisateur et a root a la base de donnee
# On defini le mot de passe pour l'utilisateur root
mariadb -v -u root << EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO 'root'@'%' IDENTIFIED BY '$DB_PASS_ROOT';
SET PASSWORD FOR 'root'@'localhost' = PASSWORD('$DB_PASS_ROOT');
EOF

# On attend pour s'assurer que MariaDB ai le temps tout mettre en place
sleep 5

# On arrete mariadb
service mariadb stop

# On lance mariadb de maniere securisee avec mysqld_safe
exec $@