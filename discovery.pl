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

say encode_json( { data => \@data } );
