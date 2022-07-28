default: ansible cue
ts:=$(shell date +"%s")

cli:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.cli

api:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.api

cue:
	time cue apply

ansible-cleanup:
	echo "#,CPU,Memory,Time" > ansible.csv

ansible-test: ansible-cleanup
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		time -o ansible.csv -f $$step,%P,%M,%E -a ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.api; \
	done

cue-cleanup:
	echo "#,CPU,Memory,Time" > cue.csv

cue-test: cue-cleanup
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		time -o cue.csv -f $$step,%P,%M,%E -a cue apply; \
	done

# requires python3 -m pip install memory_profile
ansible-memory-cleanup:
	rm -rf mprofile_ansible.dat

memory-ansible-test: ansible-memory-cleanup
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		mprof run --include-children -o mprofile_ansible.dat ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.api; \
	done
	mprof peak mprofile_ansible.dat

cue-memory-cleanup:
	rm -rf mprofile_cue.dat

memory-cue-test: cue-memory-cleanup
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		mprof run --include-children -o mprofile_cue.dat cue apply; \
	done
	mprof peak mprofile_cue.dat
	