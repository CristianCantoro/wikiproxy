all: build configfile validate proxy

build:
	docker build \
		--build-arg plugins=http.cache,tls.dns.ovh \
		--tag wikiproxy \
		github.com/abiosoft/caddy-docker.git

# WIKIPROXY_DOMAIN is defined in a file .env file that must be placed in the
# repo root. Source this file before launching `make configfile`.
configfile:
	@echo '1. Generating the configfile... '
	[ -n "${WIKIPROXY_DOMAIN}" ] && cd config && \
	python3 configgen.py config "$(WIKIPROXY_DOMAIN)" \
		--head head.Caddyfile
	rsync -a config/config.d/ caddy/config.d/
	@echo '->  success'

install: install-systemd

install-systemd:
	cp init/caddy.systemd /etc/systemd/system/

install-upstart:
	cp init/caddy.upstart /etc/init/

proxy:
	docker run --rm \
		--name wikimirror \
		-v "$(PWD)"/caddy/Caddyfile:/etc/Caddyfile \
		-v "$(PWD)"/caddy/config.d:/etc/config.d \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		wikiproxy

stop:
	docker stop wikimirror

test:
	docker run \
		-v "$(PWD)"/caddy/test.Caddyfile:/etc/Caddyfile \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		wikiproxy \
			--ca https://acme-staging.api.letsencrypt.org/directory

validate:
	@echo '2. Validate the configfile... '
	docker run \
		--rm \
		-v "$(PWD)"/caddy/Caddyfile:/etc/Caddyfile \
		-v "$(PWD)"/caddy/config.d:/etc/config.d \
		-v "$(HOME)"/.caddy:/root/.caddy \
		--env-file "$(PWD)"/caddy/*.sh \
		-p 80:80 -p 443:443 \
		wikiproxy \
			--conf /etc/Caddyfile \
			--validate
	@echo '->  success'
