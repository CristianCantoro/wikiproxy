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
        help="Configuration file for templates [default: config.json]")
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
    subparser_config.add_argument("-o", "--output",
        default='../caddy/Caddyfile',
        help="The name of the resulting Caddy config file [default: ../caddy/Caddyfile]")
    subparser_config.add_argument("-w", "--wikis",
        default='wikis.json',
        help="Configuration file for wikis [default: wikis.json]")

    args = parser.parse_args()

    if args.subcommand == 'config':
        with open(args.config) as config_file:
            config = json.load(config_file)

        with open(args.wikis) as wikis_file:
            wikis = json.load(wikis_file)

        with open(args.template) as template_file:
            template = Template(template_file.read())

        with open(args.output, 'w') as outfile:

            if args.head is not None:
                with open(args.head) as head_file:
                    template_head = Template(head_file.read())
                rendered_head = template_head.substitute(**config['head'])
                outfile.write(rendered_head)

            for lang, main in sorted(wikis.items()):
                rendered = template.substitute(domain=args.domain,
                                               lang=lang,
                                               main_page=main,
                                               **config['template']
                                               )
                outfile.write(rendered)

            if args.tail is not None:
                with open(args.tail) as tail_file:
                    template_tail = Template(tail_file.read())
                rendered_tail = template_tail.substitute(**config['tail'])
                outfile.write(rendered_tail)

    else:
        pass

    exit(0)

