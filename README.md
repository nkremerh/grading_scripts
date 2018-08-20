Grading Scripts Repository
----------------------------

This is an repository of scripts to help automate grading of programming assignments. 

The default setup for the scripts relies upon the Endlines utility:

> https://github.com/mdolidon/endlines

Endlines is useful for performing recursive conversion of end-of-line characters in files to the UNIX standard.

Before running the grading scripts, please make sure you add endlines to your path.

To do a first-time setup of the directory structure, run:

```
make setup
```

To pull the latest assignment locally, run:

```
make pull
```

To archive the previous assignment, run:

```
make archive
```

To perform a naive grading of an assignment, use simple_grader.pl:

```
perl simple_grader.pl --help
```

There are a few required options for the grader. These are: the directory to search for assignments, the soure file to run, and the command needed to execute it.

Often times, the command to test student code is the invocation of a Makefile. Here is an example invocation:

```
perl simple_grader.pl --dir curr_assignment --src regex_primer/homework.sed --cmd "make test"
```

It will probably be helpful to redirect the output of simple_grader.pl to an output file for easy parsing. The grading script will inform you whether it could find the expected assignment file and whether the generated output from the student's program matches the answer key. The script does not perform any complex matching on the answer key. So if the expected output for an assignment was: 1,2,3,4 but a student's program produced the output: 1 2 3 4, the script would flag that as incorrect even though we can easily tell the output matches the content of the answer key. Additional care for these corner cases is needed. This script is meant as a first pass for grading, not a final evaluation.

There are also a couple tools included to help manage excess data students may submit with their assignments and to manage minor misnaming issues with directories. To remove excess submitted data, run rm_excess.pl:

```
perl rm_excess.pl --dir ./curr_assignment/1/ --src challenge01
```

This will remove all other directories in a student's submission which are not challenge01. Similarly, you can run rename_assignments.pl to fix any minor misnaming issues students have with directories by running:

```
perl rename_assignments.pl --dir ./curr_assignment/1/ --src challenge01
```

This script will check each student submission to try to match all but the first character of the string passed to the --src option. For example, if a student submits the example assignment above as Challenge01, the script will catch it and rename the directory to challenge01.

You may also find older scripts in the old_scripts directory. These are for historical purposes only. They may be cannibalized for one-off grading projects in the future when needed.
