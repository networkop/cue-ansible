
## How this was built

```
ansible-galaxy collection init ansible-galaxy collection init nvidia.nvue_base
```

## How to test 

https://docs.ansible.com/ansible/devel/dev_guide/developing_collections_testing.html

```
cd nvidia/nvue_base
ansible-test sanity --docker default -v 
ansible-test units --docker default -v
ansible-test integration --docker centos8 -v
```

## How to add a role

```
cd nvidia/nvue_base/roles
ansible-galaxy role init mode
```

# Where to add a playbook

`nvidia/nvue_base/playbooks`


## How to run a playbook

from `cwd` do:

```
ansible-playbook nvidia.nvue_base.{{ debug | test }}
```