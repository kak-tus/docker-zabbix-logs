FROM alpine:3.4

MAINTAINER Andrey Kuzmin "kak-tus@mail.ru"

ENV LOGS_PATH=/logs
ENV LOGS_DISCOVERY_KEY=logs_discovery
ENV LOGS_HOSTNAME=
ENV LOGS_ZABBIX_SERVER=

COPY discovery.pl /usr/local/bin/discovery.pl

RUN apk add --update-cache perl perl-json zabbix-utils \
  && rm -rf /var/cache/apk/*
