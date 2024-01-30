FROM    debian:bookworm

EXPOSE  6379

RUN		apt update && apt install -y --no-install-recommends --no-install-suggests \
		redis && \
		rm -rf /var/lib/apt/lists/*

COPY    ./tools/redis.sh /tmp/redis.sh

RUN		chmod +x /tmp/redis.sh

CMD     ["./tmp/redis.sh"]