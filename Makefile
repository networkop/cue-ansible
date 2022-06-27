default: debug

debug:
	ansible-playbook nvidia.nvue_cli.debug

test:
	ansible-playbook  nvidia.nvue_cli.test
