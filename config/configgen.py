#!/usr/bin/env python3

import json
import argparse
from string import Template

if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("domain",
        metavar='<domain>',
        help="The domain name of the mirror")
    parser.add_argument("-c", "--config",
        default='config.json',
        help="The configuration file [default: config.json]")    
    parser.add_argument("-t", "--template",
        default='template.Caddyfile',
        help="The configuration file template [default: template.Caddyfile]")    
    parser.add_argument("--tls",
        help="The e-mail address for TLS certificates.")    
    parser.add_argument("-o", "--output",
        default='../caddy/Caddyfile',
        help="The name of the resulting Caddy config file [default: ../caddy/Caddyfile]")    

    args = parser.parse_args()

    with open(args.config) as conf_file:
        config = json.load(conf_file)

    with open(args.template) as template_file:
        template = Template(template_file.read())

    with open(args.output, 'w') as outfile:

        tls_string = ''
        if args.tls is not None:
            tls_string = 'tls {}'.format(args.tls)

        for lang, main in config.items():
            rendered = template.substitute(domain=args.domain,
                                           tls=tls_string,
                                           lang=lang,
                                           main_page=main)
            outfile.write(rendered)
