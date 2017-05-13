all: configfile validate mirror

# WIKIMIRROR_DOMAIN and WIKIMIRROR_TLS
# are defined in a file .env file that must be placed in the repo root
# Source this file before launching `make configfile`.
configfile:
	@echo '1. Generating the configfile... '
	[ ! -z "${WIKIMIRROR_DOMAIN}" ] && [ ! -z "${WIKIMIRROR_TLS}" ] && \
	cd config && python3 configgen.py "$(WIKIMIRROR_DOMAIN)" \
		--tls "$(WIKIMIRROR_TLS)" \
		--head head.Caddyfile
	@echo '->  success'

mirror:
	docker run --rm \
		--name wikimirror \
		-v "$(PWD)"/caddy/Caddyfile:/etc/Caddyfile \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		abiosoft/caddy

stop:
	docker stop wikimirror

test:
	docker run \
		-v "$(PWD)"/caddy/test.Caddyfile:/etc/Caddyfile \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		abiosoft/caddy --ca https://acme-staging.api.letsencrypt.org/directory

validate:
	@echo '2. Validate the configfile... '
	docker run --rm \
		-v "$(PWD)"/caddy/Caddyfile:/etc/Caddyfile \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		abiosoft/caddy --conf /etc/Caddyfile --validate
	@echo '->  success'
