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
