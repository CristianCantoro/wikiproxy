all: mirror

mirror:
	docker run --rm -d \
		--name wikimirror \
		-v "$(PWD)"/caddy/Caddyfile:/etc/Caddyfile \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		abiosoft/caddy

stop:
	docker stop wikimirror

test:
	docker run \
		-v "$(PWD)"/caddy/Caddyfile:/etc/Caddyfile \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		abiosoft/caddy
