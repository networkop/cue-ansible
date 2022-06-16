default: debug

debug:
	ansible-playbook nvidia.nvue_base.debug

test:
	ansible-playbook  nvidia.nvue_base.test
