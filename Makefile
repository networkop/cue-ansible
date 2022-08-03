default: ansible cue
ts:=$(shell date +"%s")

## Test Ansible CLI
ansible-cli:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.cli

## Test Ansible API
ansible-api:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.api

## Test CUE API
cue-api:
	time cue apply

## Test CUE CLI
cue-cli:
	time cue ssh

## Benchmark Ansible CLI
ansible-test-cli: 
	echo "#,CPU,Memory,Time" > ansible-cli.csv
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		time -o test-results/ansible-api.csv -f $$step,%P,%M,%E -a ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.cli; \
	done

## Benchmark Ansible API 
ansible-test-api:
	echo "#,CPU,Memory,Time" > ansible-cli.csv
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		time -o test-results/ansible-cli.csv -f $$step,%P,%M,%E -a ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.api; \
	done

## Benchmark CUE API
cue-test-api: 
	echo "#,CPU,Memory,Time" > cue-api.csv
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		time -o test-results/cue-api.csv -f $$step,%P,%M,%E -a cue apply; \
	done


## Benchmark CUE CLI
cue-test-cli: 
	echo "#,CPU,Memory,Time" > cue-cli.csv
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		time -o test-results/cue-cli.csv -f $$step,%P,%M,%E -a cue ssh; \
	done

# requires python3 -m pip install memory_profile
ansible-memory-cleanup-api:
	rm -rf test-results/mprofile_ansible_api.dat

## Benchmark Ansible API memory
memory-ansible-test-api: ansible-memory-cleanup-api
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		mprof run --include-children -o test-results/mprofile_ansible_api.dat ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.api; \
	done
	mprof peak test-results/mprofile_ansible_api.dat

ansible-memory-cleanup-cli:
	rm -rf test-results/mprofile_ansible_cli.dat

## Benchmark Ansible CLI memory
memory-ansible-test-cli: ansible-memory-cleanup-cli
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		mprof run --include-children -o test-results/mprofile_ansible_cli.dat ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.cli; \
	done
	mprof peak test-results/mprofile_ansible_cli.dat

cue-memory-cleanup-api:
	rm -rf test-results/mprofile_cue_api.dat

## Benchmark CUE API memory
memory-cue-test-api: cue-memory-cleanup-api
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		mprof run --include-children -o test-results/mprofile_cue_api.dat cue apply; \
	done
	mprof peak test-results/mprofile_cue_api.dat

cue-memory-cleanup-cli:
	rm -rf test-results/mprofile_cue_cli.dat

## Benchmark CUE CLI memory
memory-cue-test-cli: cue-memory-cleanup-cli
	for step in 1 2 3 4 5 6 7 8 9 10; do \
		mprof run --include-children -o test-results/mprofile_cue_cli.dat cue ssh; \
	done
	mprof peak test-results/mprofile_cue_cli.dat

# From: https://gist.github.com/klmr/575726c7e05d8780505a
help:
	@echo "$$(tput sgr0)";sed -ne"/^## /{h;s/.*//;:d" -e"H;n;s/^## //;td" -e"s/:.*//;G;s/\\n## /---/;s/\\n/ /g;p;}" ${MAKEFILE_LIST}|awk -F --- -v n=$$(tput cols) -v i=15 -v a="$$(tput setaf 6)" -v z="$$(tput sgr0)" '{printf"%s%*s%s ",a,-i,$$1,z;m=split($$2,w," ");l=n-i;for(j=1;j<=m;j++){l-=length(w[j])+1;if(l<= 0){l=n-i-length(w[j])-1;printf"\n%*s ",-i," ";}printf"%s ",w[j];}printf"\n";}'