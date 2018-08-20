all:
	
archive:
	perl ./archive_assignment.pl ./curr_assignment

setup:
	mkdir ./curr_assignment
	mkdir ./curr_assignment
	mkdir ./prev_assignments

pull:
	cp -r /afs/nd.edu/coursefa.18/cse/cse30332.01/dropbox/* ./curr_assignment

clean:
	rm -rf ./curr_assignment ./prev_assignments
