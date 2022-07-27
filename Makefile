default: ansible cue
ts:=$(shell date +"%s")

ansible:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.foo

api:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.api


cue:
	time cue apply

ansible-cleanup:
	echo "#,CPU,Memory" > ansible.csv

ansible-test: ansible-cleanup
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		time -o ansible.csv -f $$step,%P,%M -a ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.foo; \
	done


cue-cleanup:
	echo "#,CPU,Memory" > cue.csv

cue-test: cue-cleanup
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		time -o cue.csv -f $$step,%P,%M -a cue apply; \
	done
