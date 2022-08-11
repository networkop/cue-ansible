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
