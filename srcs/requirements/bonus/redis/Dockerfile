# On utilise l'avant derniere image de debian
FROM	debian:bullseye

# Cette image utilisera le port 6379 pour communiquer
EXPOSE  6379

# Mise a jour des packages et installation de redis
RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		redis && \
		rm -rf /var/lib/apt/lists/*

# Copie du script de configuration
COPY    ./tools/redis.sh /tmp/redis.sh

# Modification des permissions pour pouvoir executer le script dans le container
RUN		chmod +x /tmp/redis.sh

# Demarrage de redis
CMD     ["./tmp/redis.sh"]