# wikimirror

A Docker container to set up a mirror of Wikipedia using Caddy Server.

Idea from [Matt Holt](https://twitter.com/mholt6/status/858356637937016832), the creator of [Caddy Server](https://caddyserver.com/).

This is a work in progress, the goal is to have a Docker container and a set of scripts so that it is super easy (and fast!) to deploy a Wikipedia mirror. Ideally, you should only need a domain and a server with Docker.

# Usage

This should work like this:
1. Set up a DNS record for your domain/subdomain;
2. Deploy wikimirror on a server that supports Docker;
3. Enjoy your new mirror of Wikipedia.


## Known limitations

* wikilinks point to the respective domain at wikipedia.org, this issue is tracked on [Phabricator][Phabricator] as [Core should be aware of the domain it is running on and render mobile domains where necessary][T156847]

[Phabricator]: https://phabricator.wikimedia.org/
[T156847]: https://phabricator.wikimedia.org/T156847