#!/bin/bash

# On change le proprietaire des fichiers du site
chown -R www-data:www-data /var/www/inception/

# On s'assure que wp-config a bien ete copie
if [ ! -f "/var/www/inception/wp-config.php" ]; then
   mv /tmp/wp-config.php /var/www/inception/
fi

sleep 20

# On telecharge les fichiers de wordpress
wp --allow-root --path="/var/www/inception/" core download || true

# On installe les fichiers telecharges et on cree l'administrateur du site
if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    wp  --allow-root --path="/var/www/inception/" core install \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL
    # On supprime un plugin inutiles
    wp --allow-root --path="/var/www/inception/" plugin delete hello
    wp --allow-root --path="/var/www/inception/" plugin delete akismet
    # On installe redis
    wp --allow-root --path="/var/www/inception/" plugin install --activate redis-cache
    wp --allow-root --path="/var/www/inception/" plugin update --all
    wp --allow-root --path="/var/www/inception/" redis enable
fi;

if ! wp --allow-root --path="/var/www/inception/" core is-installed;
then
    echo "Failed to install wordpress"
    exit 1
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

chown -R www-data:www-data /var/www/inception/
chmod -R 755 /var/www/*

# On demarre php-fpm au premier plan
exec $@