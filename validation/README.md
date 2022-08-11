# Using CUE to validate Ansible variables

Using a custom Ansible module to:

* Validate the structure of host's variables
* Make sure only allowed variables are defined
* Ensure variables types and constraints are met



0. Starting point

Start with an existing playbook that generates a semi-structured file based on a Jinja template and a set of user-defined Ansible variables.

* `./template/frr.conf.j2` is a [golden template](https://gitlab.com/cumulus-consulting/goldenturtle/cumulus_ansible_modules/-/blob/master/roles/frr/templates/features/bgp.j2) for Cumulus FRR configuration. 
* `./host_vars/test.yml` is a set of input Ansible variables required to instantiate the above template.

1. Define a schema

Build a CUE schema for Ansible variables and define structure, types and constraints. 

```cue
package main

import (
	"net"
)

bgp: #bgp

#bgp: {
	asn:       int
	router_id: net.IPv4 & string
	peergroups: [...{
		name:      string
		remote_as: *"external" | "internal" | int
	}]
	neighbors: [...{
		interface: string, unnumbered: bool | *true, peergroup: string
	}]
	address_family: [...{
		name: "ipv4_unicast" | "l2vpn_evpn"
		redistribute: [...{
			type: string
		}]
		neighbors: [...{
			interface: string
			activate:  bool
		}]
		advertise_all_vni: bool 
	}]
	vrfs: [...{
		name:      string
		router_id: net.IPv4 & string
		address_family: [...{
			name: "ipv4_unicast" | "l2vpn_evpn"
			redistribute: [...{
				type: string
			}]
			extras: [...string]
		}]
	}]
}

```

2. Add validation task

Just before the template instantiation, add the validation task based on a custom Ansible module.

```yaml
    - name: Validate input data model with CUE
      cue_validate:
        schema: "schemas/input.cue"
        input: "{{ hostvars[inventory_hostname] | string | b64encode }}"
      delegate_to: localhost

    - name: Configure FRR
      template:
        src: "frr.conf.j2"
        dest: config/frr.conf
        mode: 0640
```

In the example above `cue_validate` is a Go binary that unifies the CUE shema with the input host variables and validates their structure, types and constraints. The source code for the module is saved in [`./src/main.go`](./src/main.go).


---

To test the successful validation scenario run `make`:

```
ansible-playbook -i hosts playbook.yml

PLAY [CUE Validation example] ************************************************************************************************************************************************************************************************************************************************

TASK [Validate input data model with CUE] ************************************************************************************************************************************************************************************************************************************
changed: [test -> localhost]

TASK [Configure FRR] *********************************************************************************************************************************************************************************************************************************************************
ok: [test]

PLAY RECAP *******************************************************************************************************************************************************************************************************************************************************************
test                       : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

To test the failed validation scenario run `make ansible-fail`:


```
ansible-playbook -i hosts --extra-vars '{"bgp": {"router_id": "192.0.2.999"}}' playbook.yml

PLAY [CUE Validation example] ************************************************************************************************************************************************************************************************************************************************

TASK [Validate input data model with CUE] ************************************************************************************************************************************************************************************************************************************
fatal: [test -> localhost]: FAILED! => {
    "busy": false,
    "changed": false
}

MSG:

Schema validation failed: bgp.router_id: invalid value "192.0.2.999" (does not satisfy net.IPv4):
    11:13
: bgp.router_id: invalid value "192.0.2.999" (does not satisfy net.IPv4)

PLAY RECAP *******************************************************************************************************************************************************************************************************************************************************************
test                       : ok=0    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```