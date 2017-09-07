Grading Scripts Repository
----------------------------

This is an repository of scripts to help automate grading of programming assignments. 

The default setup for the scripts relies upon the Endlines utility:

> https://github.com/mdolidon/endlines

Endlines is useful for performing recursive conversion of end-of-line characters in files to the UNIX standard.

To do a first-time setup of the directory structure and copy the latest assignment, run:

```
make setup
```

To archive the previous assignment and download the latest, run:

```
make archive
```

To perform a naive grading of an assignment, use simple_daily_grader.pl:

```
perl simple_daily_grader.pl --help
```

There are a few required options for the grader. The --inp option specifies extra input files. Here is an example invocation:

```
perl simple_daily_grader.pl --dir ./curr_assignment --cmd regex_primer/homework.sed --key ~/path/to/key.txt --cmd "sed -n -E -f" --inp ~/path/to/input.txt
```

It will probably be helpful to redirect the output of simple_daily_grader.pl to an output file for easy parsing. The grading script will inform you whether it could find the expected assignment file and whether the generated output from the student's program matches the answer key. The script does not perform any complex matching on the answer key. So if the expected output for an assignment was: 1,2,3,4 but a student's program produced the output: 1 2 3 4, the script would flag that as incorrect even though we can easily tell the output matches the content of the answer key. Additional care for these corner cases is needed. This script is meant as a first pass for grading, not a final evaluation.
