FROM alpine:3.4

MAINTAINER Andrey Kuzmin "kak-tus@mail.ru"

ENV LOGS_PATH=/logs
ENV LOGS_DISCOVERY_KEY=logs_discovery
ENV LOGS_ITEM_KEY=log_item
ENV LOGS_HOSTNAME=
ENV LOGS_ZABBIX_SERVER=
ENV LOGS_STORE_PATH=/store

COPY discovery.pl /etc/periodic/hourly/discovery
COPY log_items.pl /usr/local/bin/log_items.pl

RUN apk add --update-cache perl perl-json zabbix-utils \
  && ( ( crontab -l ; echo '*/2 * * * * /usr/bin/flock /tmp/log_items_lock -c /usr/local/bin/log_items.pl' ) | crontab - ) \
  && rm -rf /var/cache/apk/*

VOLUME ["/store"]

CMD crond -f
