#!/usr/bin/perl

use strict; 
use Scalar::Util qw(looks_like_number);

my $num_args = $#ARGV + 1;
if($num_args ne 1) {
	print "Must specify directory to archive.\n";
	exit 1;
}

my $dir = $ARGV[0];
my $time = time();

system("mv $dir ./$time && tar -cvzf ./$time.tar.gz $time && rm -rf ./$time && mv ./$time.tar.gz ./prev_assignments/");
exit 0;
