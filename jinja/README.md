# Converting Ansible Jinja2-based module to CUE

> Using Arista's [`eos_config` Ansible module](https://github.com/ansible-collections/arista.eos/blob/main/docs/arista.eos.eos_config_module.rst) as an example.


1. Download a Jinja2 template used by Ansible, e.g. https://github.com/aristanetworks/ansible-avd/blob/devel/ansible_collections/arista/avd/roles/eos_cli_config_gen/templates/eos/route-maps.j2

```
wget https://raw.githubusercontent.com/aristanetworks/ansible-avd/devel/ansible_collections/arista/avd/roles/eos_cli_config_gen/templates/eos/route-maps.j2
```

2. Trim the downloaded template to remove custom filters

```
cp route-map.j2 template-trimmed.j2
...Manually remove any existing custom filters...
```

3. Install `jinja2schema` library and convery the trimmed template into json schema.

```
pip install jinja2schema
./convert.py template-trimmed.j2
```

4. Using CUE API, convert the json schema into CUE definitions.

```
go run convert.go schema.json
```

Change the top-level container in `schema.cue` to definition (prepend `#`)


5. Write some CUE values, defined against the previously defined schema.
```
cat values.cue
config: {
	route_maps: #route_maps & [{
		name: "RM-MLAG-PEER-IN"
		sequence_numbers: [
			{
				sequence: 10
				set: ["origin incomplete"]
				description: "'Make routes learned over MLAG Peer-link less preferred on spines to ensure optimal routing'"
				type:        "permit"
				match: []
			},
		]
	}, {
		name: "RM-CONN-2-BGP"
		sequence_numbers: [
			{
				sequence:    10
				type:        "permit"
				description: null
				match: ["ip address prefix-list PL-LOOPBACKS-EVPN-OVERLAY"]
			},
		]
	},
	]
}
```

6. Validate the values are adhering to schema and all values are defined.

```
cue eval -c ./... 
```

7. Install `j2cli` tool to instantiate jinja templates.

```
pip install j2cli
```

8. Check resulting configuration that is built from the above CUE values and the original `template-trimmed.j2` Jinja template

```
cue test
```

9. Use CUE tooling to push the resulting configuration to the device using eAPI (json-rpc):

```
$ cue apply
CREATE RESPONSE {"jsonrpc": "2.0", "id": "172.20.20.2", "result": [{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {"messages": ["Copy completed successfully."]}]}
```