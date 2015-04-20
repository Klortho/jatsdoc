#! /usr/bin/env perl


use FindBin;

if (@ARGV < 1) {
    print "Expected taglib source directory as an argument\n";
    exit 1;
}

my $taglib_dir = $ARGV[0];

