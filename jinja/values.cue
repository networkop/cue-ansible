package main

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
