# wikiproxy

A Docker container to set up a proxy of Wikipedia using Caddy Server. Formerly also known as **wikiproxy**.

Idea from [Matt Holt](https://twitter.com/mholt6/status/858356637937016832), the creator of [Caddy Server](https://caddyserver.com/).

This is a work in progress, the goal is to have a Docker container and a set of scripts so that it is super easy (and fast!) to deploy a Wikipedia proxy. Ideally, you should only need a domain and a server with Docker.

# Usage

This should work like this:
1. Set up a DNS record for your domain/subdomain;
2. Deploy wikiproxy on a server that supports Docker;
3. Enjoy your new proxy of Wikipedia.


## Known limitations

* when visiting from mobile, the user gets redirected to `<lang>.m.wikipedia.org` regardless of the originating doman, the right thing to do would be redirect users to `<lang>.m.<original_domain.tld>`).
* <s>wikilinks point to the respective domain at wikipedia.org, this issue is tracked on [Phabricator][Phabricator] as [Core should be aware of the domain it is running on and render mobile domains where necessary][T156847]</s> (wikilinks seems correct, even if the bug is still valid).
* <s>given the [rate limits for certificates from Let's Encrypt][LE_rate_limit] of 20 certificates and the fact that each subdomain `<lang>.wikipedia.org` has its own certificate and also a corresponding mobile website at `<lang>.m.wikipedia.org`, so only 10 languages are supported at the moment. Currently [June 2017] they are the 9 biggest Wikipedias by number of articles and Turkish Wikipedia. See also this thread ["How to serve many subdomains?"][CaddyForum] on the Caddy community forum.</s> (Thanks to the fact that [since March 2018](https://letsencrypt.org/2017/07/06/wildcard-certificates-coming-jan-2018.html) Let's Encrypt supports wildcard certificate, now we are able to serve [all Wikipedias](http://wikistats.wmflabs.org/display.php?t=wp) 304 languages and also Meta-Wiki).
* `[[Special:Random]]` redirects to the main domain wikipedia.org, see [T232213 @ Wikimedia Phabricator](https://phabricator.wikimedia.org/T232213) and [caddy's issue #1011](https://github.com/caddyserver/caddy/issues/1011#issuecomment-529099024).
  
  
[CaddyForum]: https://caddy.community/t/how-to-serve-many-subdomains/2169
[LE_rate_limit]: https://letsencrypt.org/docs/rate-limits/
[Phabricator]: https://phabricator.wikimedia.org/
[T156847]: https://phabricator.wikimedia.org/T156847
