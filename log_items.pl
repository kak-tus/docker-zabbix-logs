#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;
use utf8;

use File::Basename qw(basename);
use File::Temp qw(tempfile);

my $path  = $ENV{LOGS_PATH};
my $store = $ENV{LOGS_STORE_PATH};
`mkdir -p $store`;

my $item_key = $ENV{LOGS_ITEM_KEY};

my @dirs = glob '/logs/*';

my @data;

foreach my $dir (@dirs) {
  my $log = basename($dir);

  my ( $last_file, $last_size ) = ( undef, 0 );

  if ( -e "$store/$log" ) {
    my $last_str = `cat '$store/$log'`;
    ( $last_file, $last_size ) = split '``', $last_str;
  }

  my ( $curr_file, $curr_size ) = ( undef, 0 );
  my $summary = 0;

  my @files = glob "$dir/*";

  for my $path ( sort @files ) {
    my $file = basename($path);

    next unless $file =~ m/^\d{8}$/;
    next if $last_file && $file lt $last_file;

    my $size = -s "$dir/$file";

    if ( $last_file && $file eq $last_file && $size >= $last_size ) {
      $summary += $size - $last_size;
    }
    else {
      $summary += $size;
    }

    $curr_file = $file;
    $curr_size = $size;
  }

  push @data, "- ${item_key}[$log] $summary\n";

  if ($curr_file) {
    open my $fl, ">$store/$log";
    binmode $fl, ':utf8';
    print $fl "$curr_file``$curr_size";
    close $fl;
  }
}

my ( $fh, $filename ) = tempfile();
binmode $fh, ':utf8';
print $fh @data;
close $fh;

`zabbix_sender -z $ENV{LOGS_ZABBIX_SERVER} -s $ENV{LOGS_HOSTNAME} -i $filename`;
