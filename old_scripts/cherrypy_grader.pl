#!/usr/bin/perl

use strict; 
use Scalar::Util qw(looks_like_number);
use Error qw(:try);
use Error::Simple;
use Getopt::Long qw(:config no_ignore_case);

my $num_args = $#ARGV + 1;
#if($num_args != 5) {
#	print "Must specify assignment directory, assignment source file, answer key file, command to execute upon input data file, and any other input file.\nI.E. \n";
#	exit 1;
#}

my $usage = "Simple Daily Grader Options:

Required:
	--dir <path>		Sets the directory the grader searches for submissions.
	--src <path>		Sets the path the grader searches for in each sub-directory.
	--key <path>		Specify the path to the answer key file.
	--cmd <string>		Specify the command to execute on each submission.
	
Optional:
	--inp <string>	    Specify a comma separated string of paths to each additional common input file needed.

	--help				Display this message.

Example Usage:

	perl simple_daily_grader.pl --dir ./curr_assignment --src regex_primer/homework.sed --key ~/path/to/key.txt --cmd \"sed -n -E -f\" --inp \"~/path/to/input.txt,~/path/to/input2.txt\"

";

my %OPT;
try {
    GetOptions(
		"dir=s" => \$OPT{dir},
	   	"src=s" => \$OPT{src},
	   	"key=s" => \$OPT{key},
	   	"cmd=s" => \$OPT{cmd},
	   	"inp=s" => \$OPT{inp},
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
my $key = $OPT{key};
my $cmd = $OPT{cmd};
my $inp = $OPT{inp};
my $err = 0;

if(!$dir) { print(STDERR "Missing --dir option.\n"); $err++; }
if(!$src) { print(STDERR "Missing --src option.\n"); $err++; }
if(!$key) { print(STDERR "Missing --key option.\n"); $err++; }
if(!$cmd) { print(STDERR "Missing --cmd option.\n"); $err++; }
if($err) {
	print(STDERR "Could not find $err required arguments.\n");
	print_help();
}

my @src_split = split('/', $src);
my $src_path = "";
my $s_acc = 0;
while($s_acc < scalar @src_split - 1) {
	$src_path = $src_path . $src_split[$s_acc] . "/";
	$s_acc++;
}
my $new_src = $src_split[$s_acc];

if($inp ne "") {
	my @inputs = split(',', $inp);
	foreach my $input (@inputs) {
		if($input ne "" && -e "$input") {}
		elsif($input ne "") {
			print(STDERR "Extra input file $input does not exist.\n");
			$err++;
			next;
		}
		else {}
	}
	if($err) {
		print(STDERR "Could not find $err extra input files.\nPlease check the path(s) and try again.\n");
		exit 1;
	}	
}

my @names = <$dir*>;

my $i = 0;
my @answers = ();

open(KEY, $key) or die("Could not open answer key.\n");
foreach my $answer (<KEY>) {
	chomp $answer;
	$answers[$i] = $answer;
	$i++;
}
close(KEY);

local $ENV{PATH} = "/afs/nd.edu/user14/csesoft/2017-fall/anaconda3/bin/:$ENV{PATH}";
foreach my $name (@names) {
	$i = 0;
	my @student_answers = ();
	my $wrong = 0;
	my $n = "Name not found on assignment.";
	if( -e "$name/$src") {
		open(SUB, "$name/$src");
		while(my $line = <SUB>) {
    		if(uc($line) =~ m/.*NAME:\s*\w+.*/) {
				$n = "Name found on assignment.";
				last;
			}
		}
		close(SUB);
	}
	else {
		print(STDOUT "File $name/$src does not exist.\n$name (INCORRECT)\n");
		$wrong = 1;
		next;
	}

	#my $result = system("dos2unix ./$name/*; $cmd ./$name/$input > ./$name/output.txt");
	my $result = system("cd $name/$src_path && cp ~/programming_paradigms/solutions/cherrypy/solution/tests/test_all.sh ./tests && $cmd $new_src $inp & ( cd ./tests && ./test_all.sh ) >& $new_src.output");

	open(OUTPUT,"$name/$src.output") or print("Could not find output file $name/$src.output.\n$name (INCORRECT)\n");
	foreach my $line (<OUTPUT>) {
		chomp $line;
		$student_answers[$i] = $line;
		$i++;
	}
	close(OUTPUT);

	if(scalar(@student_answers) == 0) {
		print(STDOUT "$name/$src.output is empty.\n");
		$wrong = 1;
		print "$name (INCORRECT) $n\n";
	}
	
	$i = 0;
	foreach my $answer (@student_answers) {
		if($wrong == 1) {
			print "$name (INCORRECT) $n\n";
			last;
		}
		my $curr_answer = $answers[$i];
		print(STDOUT "$name:\t$answer\t$curr_answer\n");
		if(index($answer,"$curr_answer") == -1) {
			$wrong = 1;
		}
		$i++;
	}
	if($wrong == 0) {
		print "$name (SUCCESS) $n\n";
	}

	system("ps -AF | grep \"nkremerh\" > ./python_shutdown.txt");
	my $i = 0;
	open(INPUT, "./python_shutdown.txt");
	while(my $line = <INPUT>) {
			chomp $line;
			my @parts = split(" ",$line);
			foreach my $part (@parts) {
					if($part eq "python3") {
							kill("KILL", @parts[1]);
							last;
					}
					$i++;
			}
	}
	close(INPUT);
	system("rm ./python_shutdown.txt");
}

exit 0;

sub print_help {

	print $usage;
	exit 1;
}
