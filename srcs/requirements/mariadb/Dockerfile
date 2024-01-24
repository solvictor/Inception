# On utilise la derniere image de debian
FROM	debian:bookworm

# Cette image utilisera le port 3306 pour communiquer
EXPOSE	3306

# Mise a jour des packages et installation de mariadb
RUN		apt update && \
		apt install -y --no-install-recommends --no-install-suggests \
		mariadb-server && \
		rm -rf /var/lib/apt/lists/*

# On copie notre fichier de configuration personnalise
COPY	conf/50-server.cnf /etc/mysql/mariadb.conf.d/

# On copie notre script de configuration et le rend executable
COPY	tools/setup.sh /bin/
RUN		chmod +x /bin/setup.sh

# On lance le script de configuration qui lancera mysql par la suite
CMD		["setup.sh", "mysqld_safe"]