default: ansible cue
ts:=$(shell date +"%s")

ansible:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue_cli.foo

cue:
	time cue apply