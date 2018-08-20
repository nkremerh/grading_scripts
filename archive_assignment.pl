#!/usr/bin/perl

use strict; 
use Scalar::Util qw(looks_like_number);
use Error qw(:try);
use Error::Simple;
use Getopt::Long qw(:config no_ignore_case);

my $usage = "Archiver Options:

Required:
	--src <path>		Sets the path the grader searches for in each sub-directory.
	
Optional:
	--help				Display this message.

Example Usage:

	perl archive_assignment.pl --src curr_assignment

";

my %OPT;
try {
    GetOptions(
	   	"src=s" => \$OPT{src},
	   	"help|?" => sub {print $usage; exit(0)}
	);
} 
catch Error::Simple with {
    my $E = shift;
    print STDERR $E->{-text};
    die "Failed to parse command line options.\n";
};


my $src = $OPT{src};
my $err = 0;

if(!$src) { print(STDERR "Missing --src option.\n"); $err++; }
if($err) {
	print(STDERR "Could not find $err required arguments.\n");
	print_help();
}

my $time = time();

system("mv $src ./$time && tar -cvzf ./$time.tar.gz $time && rm -rf ./$time && mv ./$time.tar.gz ./prev_assignments/");
exit 0;

sub print_help {

	print $usage;
	exit 1;
}
