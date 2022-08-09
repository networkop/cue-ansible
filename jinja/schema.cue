// bgp
bgp?: {
	// address_family
	address_family?: [...{
		// redistribute
		redistribute?: [...{
			// type
			type?: (bool | null | number | string) & (null | bool | number | string)
			...
		}]

		// name
		name?: ({
			...
		} | [...] | string | number | bool | null) & _
		...
	}]

	// neighbors
	neighbors?: [...{
		// interface
		interface?: (bool | null | number | string) & (null | bool | number | string)

		// unnumbered
		unnumbered?: ({
			...
		} | [...] | string | number | bool | null) & _

		// remote_as
		remote_as?: (bool | null | number | string) & (null | bool | number | string)

		// peergroup
		peergroup?: (bool | null | number | string) & (null | bool | number | string)
		...
	}]

	// router_id
	router_id?: (bool | null | number | string) & (null | bool | number | string)

	// peergroups
	peergroups?: [...{
		// extras
		extras?: [...(bool | null | number | string) & (null | bool | number | string)]

		// remote_as
		remote_as?: (bool | null | number | string) & (null | bool | number | string)

		// name
		name?: (bool | null | number | string) & (null | bool | number | string)
		...
	}]

	// extras
	extras?: [...(bool | null | number | string) & (null | bool | number | string)]

	// asn
	asn?: number

	// vrfs
	vrfs?: [...{
		// address_family
		address_family?: [...{
			// redistribute
			redistribute?: [...{
				// type
				type?: (bool | null | number | string) & (null | bool | number | string)
				...
			}]

			// name
			name?: ({
				...
			} | [...] | string | number | bool | null) & _
			...
		}]

		// router_id
		router_id?: (bool | null | number | string) & (null | bool | number | string)

		// extras
		extras?: [...(bool | null | number | string) & (null | bool | number | string)]

		// name
		name?: (bool | null | number | string) & (null | bool | number | string)
		...
	}]
	...
}
...
