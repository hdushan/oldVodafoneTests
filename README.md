trackandtrace
=============

Track and Trace standalone site

## Common tasks

###Running the build
Simply run `rake`

###Starting a development server
Development mode: `shotgun -o 0.0.0.0`

Notes:
* need to start the server of Fulfilment service first
* access the app at localhost:9394 instead of 9393

# Monkey Patch Warning!

Fulfilment users [Hyperclient](https://github.com/codegram/hyperclient) for its hypermedia API navigation. Hyperclient uses [Faraday](https://github.com/lostisland/faraday) to make HTTP requests. Faraday has [a bug with proxies](https://github.com/lostisland/faraday/pull/247) where it honours the `HTTP_PROXY` variable but doesn't do so with `NO_CACHE`, this means our developer machines even hit the proxy for `localhost` requests. This is no good.

There's a monkey patch in `lib/faraday_monkeypatch.rb`. It is only loaded if there's a marker file at `/etc/trackandtrace_do_monkeypatch`. **This patch should only be used on developer machines** having proxy problems.
