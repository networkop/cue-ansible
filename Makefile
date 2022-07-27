default: ansible cue
ts:=$(shell date +"%s")

ansible:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.foo

api:
	time ansible-playbook --extra-vars 'MSG=${ts}' nvidia.nvue.api


cue:
	time cue apply