---
layout: default
---

## Basic Idea

1. Set up a DNS record for your domain/subdomain;
2. Deploy wikiproxy on a server that supports Docker;
3. Enjoy your new proxy of Wikipedia.

### Plugins

We are using Caddy with these additional plugins:
* [`http.ratelimit`](https://caddyserver.com/docs/http.ratelimit)
* [`dns <provider>`](https://caddyserver.com/docs/tls.dns.ovh)


## Usage

### configgen.py

```text
./configgen.py config -h
usage: configgen.py config [-h] [-c CONFIG] [--head HEAD] [-t TEMPLATE]
                           [--tail TAIL] [-o OUTPUT] [-w WIKIS]
                           <domain>

positional arguments:
  <domain>              The domain name of the mirror

optional arguments:
  -h, --help            show this help message and exit
  -c CONFIG, --config CONFIG
                        Configuration file for templates [default:
                        config.json]
  --head HEAD           Add the content of HEAD file to the beginningof the
                        generated config file
  -t TEMPLATE, --template TEMPLATE
                        The configuration file template [default:
                        template.Caddyfile]
  --tail TAIL           Add the content of TAIL file to the endof the
                        generated config file
  -o OUTPUT, --output OUTPUT
                        The name of the resulting Caddy config file [default:
                        ../caddy/Caddyfile]
  -w WIKIS, --wikis WIKIS
                        Configuration file for wikis [default: wikis.json]
```

## License

This project is released under the MIT license.