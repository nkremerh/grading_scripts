all:
	
archive:
	perl ./archive_assignment.pl ./curr_assignment

setup:
	mkdir ./curr_assignment
	mkdir ./curr_assignment/1
	mkdir ./curr_assignment/2
	mkdir ./prev_assignments

pull:
	cp -r /afs/nd.edu/coursesp.18/cse/cse20312.01/dropbox/* ./curr_assignment/1
	cp -r /afs/nd.edu/coursesp.18/cse/cse20312.02/dropbox/* ./curr_assignment/2

clean:
	rm -rf ./curr_assignment ./prev_assignments
