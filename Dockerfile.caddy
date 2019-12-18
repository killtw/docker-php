FROM killtw/php:1.1.0

COPY --from=abiosoft/caddy /usr/bin/caddy /usr/bin/caddy

EXPOSE 2015

CMD ["/usr/bin/caddy", "--conf", "/etc/Caddyfile", "--log", "stdout"]
