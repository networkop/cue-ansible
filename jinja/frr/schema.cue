package schema

// bgp
#bgp: {
	// address_family
	address_family?: [...{
		// name
		name: ({
			...
		} | [...] | string | number | bool | null) & _

		// redistribute
		redistribute?: [...{
			// type
			type: (bool | null | number | string) & (null | bool | number | string)
			...
		}]
		...
	}]

	// vrfs
	vrfs?: [...{
		// router_id
		router_id: (bool | null | number | string) & (null | bool | number | string)

		// address_family
		address_family?: [...{
			// name
			name: ({
				...
			} | [...] | string | number | bool | null) & _

			// redistribute
			redistribute?: [...{
				// type
				type: (bool | null | number | string) & (null | bool | number | string)
				...
			}]
			...
		}]

		// extras
		extras?: [...(bool | null | number | string) & (null | bool | number | string)]

		// name
		name: (bool | null | number | string) & (null | bool | number | string)
		...
	}]

	// neighbors
	neighbors: [...{
		// interface
		interface: (bool | null | number | string) & (null | bool | number | string)

		// peergroup
		peergroup: (bool | null | number | string) & (null | bool | number | string)

		// unnumbered
		unnumbered?: ({
			...
		} | [...] | string | number | bool | null) & _

		// remote_as
		remote_as: (bool | null | number | string) & (null | bool | number | string)
		...
	}]

	// router_id
	router_id: (bool | null | number | string) & (null | bool | number | string)

	// asn
	asn: number

	// peergroups
	peergroups?: [...{
		// remote_as
		remote_as: (bool | null | number | string) & (null | bool | number | string)

		// extras
		extras?: [...(bool | null | number | string) & (null | bool | number | string)]

		// name
		name: (bool | null | number | string) & (null | bool | number | string)
		...
	}]

	// extras
	extras?: [...(bool | null | number | string) & (null | bool | number | string)]
	...
}
...
