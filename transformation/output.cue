package main

import (
	"net"
)

#inventory: ["dc1-leaf1a", "dc1-leaf1b"]

config: {
	for device in #inventory {
		let input = avd_switch_facts[device].switch

		"\(device)": {
			mlag_configuration: {
				domain_id:       input.group
				local_interface: "Vlan\(input.mlag_peer_vlan)"
				peer_address:    input.mlag_peer_ip & net.IPv4
				peer_link:       "Port-Channel\(input.mlag_port_channel_id)"
			}

			router_bgp: {
				let bgp = input.bgp_peer_groups.mlag_ipv4_underlay_peer
				
				peer_groups: "\(bgp.name)": {
					type:           "ipv4"
					remote_as:      input.bgp_as
					next_hop_self:  true
					description:    input.mlag_peer
					password:       bgp.password
					maximum_routes: 12000
					send_community: "all"
					route_map_in:   "RM-MLAG-PEER-IN"
					struct_cfg:     bgp.structured_config
				}
				address_family_ipv6: peer_groups: "\(bgp.name)": activate: true
				address_family_ipv4: peer_groups: "\(bgp.name)": activate: true
				neighbors: "\(input.mlag_peer_l3_ip & net.IPv4)": {
					peer_group:  "\(bgp.name)"
					description: input.mlag_peer
				}
			}
		}
	}
}
