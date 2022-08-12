package main

// from https://github.com/aristanetworks/ansible-avd/blob/v3.7.0/ansible_collections/arista/avd/examples/single-dc-l3ls/intended/structured_configs/dc1-leaf2c-debug-vars.yml
avd_switch_facts: {
	"dc1-leaf1a": switch: {
		bgp_as: "65101"
		bgp_peer_groups: mlag_ipv4_underlay_peer: {
			name:              "MLAG-IPv4-UNDERLAY-PEER"
			password:          "4b21pAdCvWeAqpcKDFMdWw=="
			structured_config: null
		}
		group:                        "DC1_L3_LEAF1"
		hostname:                     "dc1-leaf1a"
		id:                           1
		mlag:                         true
		mlag_dual_primary_detection:  false
		mlag_ibgp_origin_incomplete:  true
		mlag_ip:                      "10.255.1.64"
		mlag_l3:                      true
		mlag_l3_ip:                   "10.255.1.96"
		mlag_peer:                    "dc1-leaf1b"
		mlag_peer_ip:                 "10.255.1.65"
		mlag_peer_ipv4_pool:          "10.255.1.64/27"
		mlag_peer_l3_ip:              "10.255.1.97"
		mlag_peer_l3_ipv4_pool:       "10.255.1.96/27"
		mlag_peer_l3_vlan:            4093
		mlag_peer_link_allowed_vlans: "2-4094"
		mlag_peer_mgmt_ip:            "172.16.1.102"
		mlag_peer_vlan:               4094
		mlag_port_channel_id:         "3"
		mlag_role:                    "primary"
		mlag_support:                 true
		underlay_ipv6:                false
		underlay_router:              true
		underlay_routing_protocol:    "ebgp"
	}
	"dc1-leaf1b": switch: {
		bgp_as: "65101"
		bgp_peer_groups: mlag_ipv4_underlay_peer: {
			name:              "MLAG-IPv4-UNDERLAY-PEER"
			password:          "4b21pAdCvWeAqpcKDFMdWw=="
			structured_config: null
		}
		group:                        "DC1_L3_LEAF1"
		hostname:                     "dc1-leaf1b"
		id:                           1
		mlag:                         true
		mlag_dual_primary_detection:  false
		mlag_ibgp_origin_incomplete:  true
		mlag_ip:                      "10.255.1.65"
		mlag_l3:                      true
		mlag_l3_ip:                   "10.255.1.96"
		mlag_peer:                    "dc1-leaf1a"
		mlag_peer_ip:                 "10.255.1.64"
		mlag_peer_ipv4_pool:          "10.255.1.64/27"
		mlag_peer_l3_ip:              "10.255.1.97"
		mlag_peer_l3_ipv4_pool:       "10.255.1.96/27"
		mlag_peer_l3_vlan:            4093
		mlag_peer_link_allowed_vlans: "2-4094"
		mlag_peer_mgmt_ip:            "172.16.1.102"
		mlag_peer_vlan:               4094
		mlag_port_channel_id:         "3"
		mlag_role:                    "primary"
		mlag_support:                 true
		underlay_ipv6:                false
		underlay_router:              true
		underlay_routing_protocol:    "ebgp"
	}
}
