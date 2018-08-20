all:
	
archive:
	perl ./archive_assignment.pl --src ./curr_assignment

setup:
	mkdir ./curr_assignment
	mkdir ./prev_assignments

pull:
	mkdir ./curr_assignment || true
	cp -r /afs/nd.edu/coursefa.18/cse/cse30332.01/dropbox/* ./curr_assignment

clean:
	rm -rf ./curr_assignment ./prev_assignments
