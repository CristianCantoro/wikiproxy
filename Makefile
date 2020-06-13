TEST := $(filter test,$(MAKECMDGOALS))
WIKIPROXY_CADDYFILE ?= Caddyfile
WIKIPROXY_HEAD_TEMPLATE ?= head.Caddyfile
WIKIPROXY_TEMPLATE ?= template.Caddyfile

# Check that given variables are set and all have non-empty values,
# die with an error otherwise.
#
# Params:
#   1. Variable name(s) to test.
#   2. (optional) Error message to print.
check_defined = \
	$(strip $(foreach 1,$1, \
		$(call __check_defined,$1,$(strip $(value 2)))))
__check_defined = \
	$(if $(value $1),, \
	  $(error Undefined $1$(if $2, ($2))))

all: build configfile validate proxy

build:
	docker build \
		--build-arg plugins=ratelimit,cache,ovh \
		--tag wikiproxy \
		github.com/abiosoft/caddy-docker.git

configfile:
	@echo '1. Generating the configfile... '
	@:$(call check_defined, WIKIPROXY_DOMAIN, \
		the domain where wikiproxy will be served)
	cd config && python3 configgen.py config "$(WIKIPROXY_DOMAIN)" \
		--head "$(WIKIPROXY_HEAD_TEMPLATE)" \
		--template "$(WIKIPROXY_TEMPLATE)" \
		--output ../caddy/"$(WIKIPROXY_CADDYFILE)"
	rsync -a config/config.d/ caddy/config.d/
	@echo '->  success'

install: install-systemd

install-systemd:
	cp init/caddy.systemd /etc/systemd/system/

install-upstart:
	cp init/caddy.upstart /etc/init/

proxy: build configfile
	docker run --rm \
		--name wikimirror \
		-v "$(PWD)"/caddy/Caddyfile:/etc/Caddyfile \
		-v "$(PWD)"/caddy/config/config.d:/etc/config.d \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		wikiproxy

stop:
	docker stop wikimirror

test: WIKIPROXY_CADDYFILE = test.Caddyfile
test: build configfile validate
	docker run \
		-v "$(PWD)"/caddy:/etc/caddy \
		-v "$(HOME)"/.caddy:/root/.caddy \
		--env-file "$(PWD)"/caddy/env.test.sh \
		-p 80:80 -p 443:443 \
		wikiproxy \
		  -conf /etc/caddy/"$(WIKIPROXY_CADDYFILE)" \
		  -ca https://acme-staging-v02.api.letsencrypt.org/directory \
		  -agree

test-local: WIKIPROXY_DOMAIN = localhost
test-local: WIKIPROXY_CADDYFILE = local.Caddyfile
test-local: WIKIPROXY_HEAD_TEMPLATE = head.local.Caddyfile
test-local: WIKIPROXY_TEMPLATE = template.local.Caddyfile
test-local: build configfile validate
	$(eval tmpdir := $(shell mktemp --directory wikiproxy.log.XXXXXX))
	docker run \
		--rm \
		-v "$(PWD)"/caddy:/etc/caddy \
		-v "$(PWD)/$(tmpdir)":/var/log/caddy/ \
		--env WIKIPROXY_DOMAIN="${WIKIPROXY_DOMAIN}" \
		-p 6000:6000 \
		wikiproxy \
		  -conf /etc/caddy/"$(WIKIPROXY_CADDYFILE)"
	rm -rf ${tmpdir}

validate:
	@echo '2. Validate the configfile... '
	docker run \
		--rm \
		-v "$(PWD)"/caddy:/etc/caddy \
		-v "$(HOME)"/.caddy:/root/.caddy \
		-p 80:80 -p 443:443 \
		$(if $(TEST),--env-file "$(PWD)"/caddy/env.test.sh,) \
		wikiproxy \
		  -conf /etc/caddy/"$(WIKIPROXY_CADDYFILE)" \
		  -validate
	@echo '->  success'
