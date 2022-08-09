package main

import (
	eos "jinja.cue/arista:schema"
	frr "jinja.cue/frr:schema"
)

// losely based on https://github.com/arista-netdevops-community/ansible-avd-cloudvision-demo/blob/master/inventory/intended/structured_configs/DC1-LEAF1A.yml#L773
arista: {
	route_maps: eos.#route_maps & [{
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
				sequence: 10
				type:     "permit"
				set: []
				description: null
				match: ["ip address prefix-list PL-LOOPBACKS-EVPN-OVERLAY"]
			},
		]
	},
	]
}

// losely based on https://gitlab.com/cumulus-consulting/goldenturtle/cumulus_ansible_modules/-/blob/master/inventories/evpn_symmetric/group_vars/leaf/common.yml#L91
nvidia: {
	bgp: frr.#bgp & {
		asn:       65123
		router_id: "192.0.2.1"
		address_family: [{
			name: "ipv4_unicast"
			redistribute: [{type: "connected"}]
		},{
			name: "l2vpn_evpn"
			neighbors: [{
				interface: "underlay"
				activate: true
			}]
			advertise_all_vni: true
		}]
		peergroups: [{
			name:      "underlay"
			remote_as: "external"
		}]
		neighbors: [{
			interface:  "swp51"
			unnumbered: true
			peergroup:  nvidia.bgp.peergroups[0].name
			remote_as:  "external"
		}, {
			interface:  "swp52"
			unnumbered: true
			peergroup:  nvidia.bgp.peergroups[0].name
			remote_as:  "external"
		}]
		vrfs: [{
			name:      "RED"
			router_id: nvidia.bgp.router_id
			address_family: [{
				name: "ipv4_unicast"
				redistribute: [{type: "connected"}]
			}, {
				name: "l2vpn_evpn"
				extras: ["advertise ipv4 unicast"]
			}]
		}]
	}
}
