FROM alpine:3.4

MAINTAINER Andrey Kuzmin "kak-tus@mail.ru"

ENV LOGS_PATH=/logs

COPY discovery.pl /usr/local/bin/discovery.pl

RUN apk add --update-cache perl perl-json \
  && rm -rf /var/cache/apk/*
