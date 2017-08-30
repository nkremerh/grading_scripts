#!/usr/bin/perl

use strict; 
use Scalar::Util qw(looks_like_number);

my $num_args = $#ARGV + 1;
if($num_args != 2) {
	print(STDERR "Must specify assignment directory, assignment source file\n");
	exit 1;
}

my $dir = $ARGV[0];
my $src = $ARGV[1];

my @names = <$dir*>;

foreach my $name (@names) {
	if( -e "$name/$src") { }
	else {
		print(STDERR "File $name/$src does not exist.\n");
		next;
	}
	
	my $result = system("cd $name && rm $src.output");
	
}
exit 0;
