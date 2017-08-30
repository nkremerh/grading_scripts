all:
	
setup:
	perl ./archive_assignment.pl ./curr_assignment
	mkdir ./curr_assignment && cp -r /afs/nd.edu/coursefa.17/cse/cse30332.01/dropbox/* ./curr_assignment
	endlines unix -r ./curr_assignment

clean:
	rm -rf ./test.txt
