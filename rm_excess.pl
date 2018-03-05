#!/usr/bin/perl

use strict;
use Scalar::Util qw(looks_like_number);
use Error qw(:try);
use Error::Simple;
use Getopt::Long qw(:config no_ignore_case);

my $usage = "Excess Data Remover Options:

Required:
    --dir <path>        Sets the directory the script searches for submissions.
    --src <path>        Sets the path within --dir the script keeps.

Optional:
    --help              Display this message.

Example Usage:

    perl rm_excess.pl --dir ./curr_assignment/1 --src challenge01

";

my %OPT;
try {
    GetOptions(
        "dir=s" => \$OPT{dir},
        "src=s" => \$OPT{src},
        "help|?" => sub {print $usage; exit(0)}
    );
}
catch Error::Simple with {
    my $E = shift;
    print STDERR $E->{-text};
    die "Failed to parse command line options.\n";
};

my $dir = $OPT{dir};
my $src = $OPT{src};
my $err = 0;

if(!$dir) { print(STDERR "Missing --dir option.\n"); $err++; }
if(!$src) { print(STDERR "Missing --src option.\n"); $err++; }
if($err) {
    print(STDERR "Could not find $err required arguments.\n");
    print_help();
}

my @names = <$dir*>;

foreach my $name (@names) {
	my @inner_dir = <$name/*>;
	foreach my $d (@inner_dir) {
		if($d ne "$name/$src") {
			system("rm -rf $d");
		}
		else {
			print("$name/$src\n");
		}
	}
}

exit 0;

sub print_help {

    print $usage;
    exit 1;
}
