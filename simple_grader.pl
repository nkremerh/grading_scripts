#!/usr/bin/perl

use strict; 
use Scalar::Util qw(looks_like_number);
use Error qw(:try);
use Error::Simple;
use Getopt::Long qw(:config no_ignore_case);

my $usage = "Simple Grader Options:

Required:
	--dir <path>		Sets the directory the grader searches for submissions.
	--src <path>		Sets the path the grader searches for in each sub-directory.
	--cmd <string>		Specify the command to execute on each submission.
	
Optional:
	--help				Display this message.

Example Usage:

	perl simple_grader.pl --dir ./curr_assignment --src challenge01 --cmd \"make test\"

";

my %OPT;
try {
    GetOptions(
		"dir=s" => \$OPT{dir},
	   	"src=s" => \$OPT{src},
	   	"cmd=s" => \$OPT{cmd},
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
my $cmd = $OPT{cmd};
my $err = 0;

if(!$dir) { print(STDERR "Missing --dir option.\n"); $err++; }
if(!$src) { print(STDERR "Missing --src option.\n"); $err++; }
if(!$cmd) { print(STDERR "Missing --cmd option.\n"); $err++; }
if($err) {
	print(STDERR "Could not find $err required arguments.\n");
	print_help();
}

my @names = <$dir*>;
foreach my $name (@names) {
	my @name_split = split('/', $name);
	my $s_acc = 0;
	while($s_acc < scalar @name_split - 1) {
		$s_acc++;
	}
	my $just_name = $name_split[$s_acc];

	if( -e "$name/$src") {
		print(STDOUT "Running $just_name\'s code.\n"); 
	}
	else {
		print(STDOUT "Could not find $just_name\'s code.\n\n");
		next;
	}	

	my $result = system("cd $name/$src && endlines unix -r ./* && timeout 60 $cmd");
	if($result) {
		print(STDOUT "Encountered error while running $just_name\'s code.\n\n");
	}
	else {
		print(STDOUT "Successfully ran $just_name\'s code.\n\n");
	}
}

exit 0;

sub print_help {

	print $usage;
	exit 1;
}
