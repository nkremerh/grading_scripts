#!/usr/bin/perl

use strict; 
use Scalar::Util qw(looks_like_number);

my $num_args = $#ARGV + 1;
if($num_args != 5) {
	print "Must specify assignment directory, assignment source file, answer key file, command to execute upon input data file, and any other input file.\nI.E. perl ./simple_daily_grader.pl ./curr_assignment homework.sed ./output.txt \"sed -n -E -f\" input.txt\n";
	exit 1;
}

my $dir = $ARGV[0];
my $src = $ARGV[1];
my $key = $ARGV[2];
my $command = $ARGV[3];
my $input = $ARGV[4];

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
	if( -e "$name/$src") { }
	else {
		print(STDOUT "File $name/$src does not exist.\n$name (INCORRECT)\n");
		$wrong = 1;
		next;
	}
	if($input ne "" && -e "$input") {}
	else {
		print(STDOUT "Extra input file $input does not exist.\n$name (INCORRECT)\n");
		$wrong = 1;
		next;
	}

	#my $result = system("dos2unix ./$name/*; $command ./$name/$input > ./$name/output.txt");
	my $result = system("cd $name && $command $src $input > $src.output");
	
	open(OUTPUT,"$src.output");
	foreach my $line (<OUTPUT>) {
		chomp $line;
		$student_answers[$i] = $line;
		$i++;
	}
	close(OUTPUT);

	$i = 0;
	foreach my $answer (@student_answers) {
		if($wrong eq 1) {
			last;
		}
		my $curr_answer = $answers[$i];
		if(index($answer,"$curr_answer") eq -1) {
			print $answer . " : " . $answers[$i] . "\n";
			print "$name (INCORRECT)\n";
			$wrong = 1;
			last;
		}
		$i++;
	}
	if($wrong eq 0) {
		print "$name (SUCCESS)\n";
	}
}
exit 0;
