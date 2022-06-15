default: debug

debug:
	ansible-playbook networkop.nvue_base.debug

test:
	ansible-playbook  networkop.nvue_base.test -vvv
