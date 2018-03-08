#!/usr/bin/perl

use strict; 
use Scalar::Util qw(looks_like_number);
use Error qw(:try);
use Error::Simple;
use Getopt::Long qw(:config no_ignore_case);

my $usage = "Assignment Renamer Options:

Required:
    --dir <path>        Sets the directory the script searches for submissions.
    --src <path>        Sets the path within --dir the script tries to match and rename.

Optional:
    --help              Display this message.

Example Usage:

    perl rename_assignments.pl --dir ./curr_assignment/1 --src challenge01

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

my $match = $src;
$match =~ s/^.//;

my @names = <$dir*>;

foreach my $name (@names) {
	my @inner_dir = <$name/*>;
	foreach my $d (@inner_dir) {
		if($d =~ m/.*$match.*/ and $d ne "$name/$src") {
			print(STDERR "Match found.\n");
			system("mv $d $name/$src");
		}
	}
}

exit 0;

sub print_help {

    print $usage;
    exit 1;
}
