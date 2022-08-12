
ansible: 
	ansible-playbook -i hosts playbook.yml

import:
	cue import  --outfile input.cue -p main -f group_vars/all.yml

transform:
	cue transform

diff:
	dyff between out/dc1-leaf1a.yml out/dc1-leaf1a.json