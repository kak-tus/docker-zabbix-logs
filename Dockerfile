FROM alpine:3.4

MAINTAINER Andrey Kuzmin "kak-tus@mail.ru"

ENV LOGS_PATH=/logs
ENV LOGS_DISCOVERY_KEY=logs_discovery
ENV LOGS_ITEM_KEY=log_item
ENV LOGS_HOSTNAME=
ENV LOGS_ZABBIX_SERVER=
ENV LOGS_STORE_PATH=/store

COPY discovery.pl /usr/local/bin/discovery.pl
COPY log_items.pl /usr/local/bin/log_items.pl

RUN apk add --update-cache perl perl-json zabbix-utils \
  && rm -rf /var/cache/apk/*

VOLUME ["/store"]
