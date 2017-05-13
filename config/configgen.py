#!/usr/bin/env python3

import json
import argparse
from string import Template


def include_file(source_name, target_fp):
    """
    Includes the contents of the source file
    named source_name writing to a target file.
    target_fp must be a file pointer.
    """

    with open(source_name, 'r') as sourcefile:
        text_to_include = sourcefile.read()

    target_fp.write(text_to_include)


if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(title='subcommands',
                                       dest='subcommand',
                                       description='valid subcommands',
                                       help='additional help')
    subparser_config = subparsers.add_parser('config')
    subparser_test = subparsers.add_parser('test')

    subparser_config.add_argument("domain",
        metavar='<domain>',
        help="The domain name of the mirror")
    subparser_config.add_argument("-c", "--config",
        default='config.json',
        help="The configuration file [default: config.json]")    
    subparser_config.add_argument("--head",
        action='store',
        help="Add the content of HEAD file to the beginning"
             "of the generated config file")
    subparser_config.add_argument("-t", "--template",
        default='template.Caddyfile',
        help="The configuration file template [default: template.Caddyfile]")    
    subparser_config.add_argument("--tail",
        action='store',
        help="Add the content of TAIL file to the end"
             "of the generated config file")
    subparser_config.add_argument("--tls",
        help="The e-mail address for TLS certificates.")    
    subparser_config.add_argument("-o", "--output",
        default='../caddy/Caddyfile',
        help="The name of the resulting Caddy config file [default: ../caddy/Caddyfile]")    

    args = parser.parse_args()

    if args.subcommand == 'config':
        with open(args.config) as conf_file:
            config = json.load(conf_file)

        with open(args.template) as template_file:
            template = Template(template_file.read())

        with open(args.output, 'w') as outfile:

            tls_string = ''
            if args.tls is not None:
                tls_string = 'tls {}'.format(args.tls)

            if args.head is not None:
                include_file(args.head, outfile)

            for lang, main in config.items():
                rendered = template.substitute(domain=args.domain,
                                               tls=tls_string,
                                               lang=lang,
                                               main_page=main)
                outfile.write(rendered)

            if args.tail is not None:
                include_file(args.tail, outfile)

    else:
        pass