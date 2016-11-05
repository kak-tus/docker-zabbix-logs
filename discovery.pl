#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;
use utf8;

use JSON qw(encode_json);
use File::Basename qw(basename);

my $path = $ENV{LOGS_PATH};

my @dirs = glob '/logs/*';

my @data;
foreach my $dir (@dirs) {
  $dir = basename($dir);
  push @data, { '{#LOG}' => $dir };
}

my $val = encode_json( { data => \@data } );

say `zabbix_sender -z $ENV{LOGS_ZABBIX_SERVER} -s $ENV{LOGS_HOSTNAME} -k '$ENV{LOGS_DISCOVERY_KEY}' -o '$val'`;
