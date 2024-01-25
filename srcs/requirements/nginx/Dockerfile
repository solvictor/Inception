# On utilise la derniere image de debian
FROM	debian:bookworm

# Cette image utilisera le port 443 pour communiquer
EXPOSE	443

# Mise a jour des packages et installation de nginx et OpenSSL et supression de la liste des packages telecharges pour reduire la taille de l'image
RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		nginx \
		openssl && \
		rm -rf /var/lib/apt/lists/*

# Definition des arguments pour les informations du certificat SSL
ARG		CERT_FOLDER CERTIFICATE KEY COUNTRY STATE LOCALITY ORGANIZATION UNIT COMMON_NAME

# Creation du repertoire pour le certificat SSL et generation du certificat auto-signe
RUN mkdir -p ${CERT_FOLDER} && \
	openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
    -out ${CERTIFICATE} \
    -keyout ${KEY} \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}"

# Copie des fichiers de configuration Nginx
COPY	conf/nginx.conf	/etc/nginx/
COPY	conf/server.conf	/etc/nginx/conf.d/

# Ajout des informations au fichier de configuration du serveur Nginx
RUN		echo "\tserver name ${COMMON_NAME};\n\
			\tssl_certificate ${CERTIFICATE};\n\
			\tssl_certificate_key ${KEY};\n\
			}" >> /etc/nginx/conf.d/server.conf

# Creation un repertoire pour le contenu du site web et mise a jour des permissions
RUN		mkdir -p /var/www/
RUN		chown -R www-data:www-data /var/www/

# Demarrage nginx en desactivant le mode daemon
CMD		["nginx", "-g", "daemon off;"]