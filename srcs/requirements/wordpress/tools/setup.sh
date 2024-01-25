#!/bin/bash

# On change le proprietaire des fichiers du site
chown -R www-data:www-data /var/www/inception/

# On s'assure que wp-config a bien ete copie
if [ ! -f "/var/www/inception/wp-config.php" ]; then
   mv /tmp/wp-config.php /var/www/inception/
fi

sleep 10

# On telecharge les fichiers de wordpress
wp --allow-root --path="/var/www/inception/" core download || true

# On installe les ficheirs telecharges et on cree l'administrateur du site
if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
fi;

# On cree un utilisateur sur le site
if ! wp --allow-root --path="/var/www/inception/" user get $WP_USER;
then
    wp  --allow-root --path="/var/www/inception/" user create \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=$WP_ROLE
fi;

# On installe le theme raft
wp --allow-root --path="/var/www/inception/" theme install raft --activate 

# TODO Test si les perms sont bonnes sans ca
# chown -R www-data:www-data /var/www/inception/
# chmod -R 755 /var/www/*

# On demarre php-fpm au premier plan
exec $@