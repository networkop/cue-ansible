
## How this was built

```
ansible-galaxy collection init ansible-galaxy collection init networkop.nvue_base
```

## How to test 

https://docs.ansible.com/ansible/devel/dev_guide/developing_collections_testing.html

```
cd nvidia/bluefield
ansible-test sanity --docker default -v 
ansible-test units --docker default -v
ansible-test integration --docker centos8 -v
```

## How to add a role

```
cd nvidia/bluefield/roles
ansible-galaxy role init mode
```

# Where to add a playbook

`nvidia/bluefield/playbooks`


## How to run a playbook

from `cwd` do:

```
ansible-playbook nvidia.bluefield.{{ debug | network | mode_separated }}
```