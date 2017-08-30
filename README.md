Grading Scripts Repository
----------------------------

This is an repository of scripts to help automate grading of programming assignments. 

The default setup for the scripts relies upon the Endlines utility:

> https://github.com/mdolidon/endlines

Endlines is useful for performing recursive conversion of end-of-line characters in files to the UNIX standard.

To archive the previous assignment and download the latest, run:

```
make setup
```

To perform a naive grading of an assignment, use simple_daily_grader.pl:

```
perl simple_daily_grader.pl <target directory (default named curr_assignment)> <target assignment name (i.e. regex_primer/homework.sed)> <answer key file> <command to execute the assignment (i.e. "sed -n -E -f")> <other input file (i.e. ~/path/to/input.txt)>
```

It will probably be helpful to redirect the output of simple_daily_grader.pl to an output file for easy parsing. The grading script will inform you whether it could find the expected assignment file and whether the generated output from the student's program matches the answer key. The script does not perform any complex matching on the answer key. So if the expected output for an assignment was: 1,2,3,4 but a student's program produced the output: 1 2 3 4, the script would flag that as incorrect even though we can easily tell the output matches the content of the answer key. Additional care for these corner cases is needed. This script is meant as a first pass for grading, not a final evaluation.
