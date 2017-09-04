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
	elsif($input ne "") {
		print(STDOUT "Extra input file $input does not exist.\n$name (INCORRECT)\n");
		$wrong = 1;
		next;
	}
	else {}

	#my $result = system("dos2unix ./$name/*; $command ./$name/$input > ./$name/output.txt");
	my $result = system("cd $name && $command $src $input > $src.output");
	
	open(OUTPUT,"$name/$src.output") or die "Could not find output.\n";
	foreach my $line (<OUTPUT>) {
		chomp $line;
		$student_answers[$i] = $line;
		$i++;
	}
	close(OUTPUT);

	if(scalar(@student_answers) == 0) {
		print(STDOUT "$name/$src.output is empty.\n");
		$wrong = 1;
		print "$name (INCORRECT)\n";
	}
	
	$i = 0;
	foreach my $answer (@student_answers) {
		if($wrong == 1) {
			print "$name (INCORRECT)\n";
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
		print "$name (SUCCESS)\n";
	}
}
exit 0;
