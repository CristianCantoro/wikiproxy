# wikiproxy

A Docker container to set up a proxy of Wikipedia using Caddy Server. Formerly also known as **wikiproxy**.

Idea from [Matt Holt](https://twitter.com/mholt6/status/858356637937016832), the creator of [Caddy Server](https://caddyserver.com/).

This is a work in progress, the goal is to have a Docker container and a set of scripts so that it is super easy (and fast!) to deploy a Wikipedia proxy. Ideally, you should only need a domain and a server with Docker.


# Plugins

We are using Caddy with these additional plugins:
* [`http.ratelimit`](https://caddyserver.com/docs/http.ratelimit)
* [`dns <provider>`](https://caddyserver.com/docs/tls.dns.ovh)
* [`http.cache`](https://caddyserver.com/docs/http.cache)


# Usage

This should work like this:
1. Set up a DNS record for your domain/subdomain;
2. Deploy wikiproxy on a server that supports Docker;
3. Enjoy your new proxy of Wikipedia.


## Known limitations

* when visiting from mobile, the user gets redirected to `<lang>.m.wikipedia.org` regardless of the originating doman, the right thing to do would be redirect users to `<lang>.m.<original_domain.tld>`).
* <s>wikilinks point to the respective domain at wikipedia.org, this issue is tracked on [Phabricator][Phabricator] as [Core should be aware of the domain it is running on and render mobile domains where necessary][T156847]</s> (wikilinks seems correct, even if the bug is still valid).

[CaddyForum]: https://caddy.community/t/how-to-serve-many-subdomains/2169
[LE_rate_limit]: https://letsencrypt.org/docs/rate-limits/
[Phabricator]: https://phabricator.wikimedia.org/
[T156847]: https://phabricator.wikimedia.org/T156847
