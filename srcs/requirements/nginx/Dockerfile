# On utilise la derniere image de debian
FROM	debian:bookworm

# Cette image utilisera le port 443 pour communiquer
EXPOSE	443

# Mise a jour des packages et installation de nginx et OpenSSL et supression de la liste des packages telecharges pour reduire la taille de l'image
RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl && \
		rm -rf /var/lib/apt/lists/*

# Creation du repertoire pour le certificat SSL et generation du certificat auto-signe
RUN mkdir -p /etc/nginx/certs/ && \
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out /etc/nginx/certs/certificate.crt \
    -keyout /etc/nginx/certs/certificate.key \
    -subj "/C=FR/ST=IDF/L=paris/O=42/OU=42/CN=vegret.42.fr"

# Copie des fichiers de configuration Nginx
COPY	conf/nginx.conf	/etc/nginx/
COPY	conf/server.conf	/etc/nginx/conf.d/

# Creation un repertoire pour le contenu du site web et mise a jour des permissions
RUN		mkdir -p /var/www/
RUN		chown -R www-data:www-data /var/www/

# Demarrage nginx en desactivant le mode daemon
CMD		["nginx", "-g", "daemon off;"]