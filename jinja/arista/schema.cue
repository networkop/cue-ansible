package schema

// route_maps
#route_maps: [...{
	// name
	name: (bool | null | number | string) & (null | bool | number | string)

	// sequence_numbers
	sequence_numbers: [...{
		// description
		description: (bool | null | number | string) & (null | bool | number | string)

		// sequence
		sequence: (bool | null | number | string) & (null | bool | number | string)

		// type
		type: (bool | null | number | string) & (null | bool | number | string)

		// match
		match: [...(bool | null | number | string) & (null | bool | number | string)]

		// set
		set: [...(bool | null | number | string) & (null | bool | number | string)]
		...
	}]
	...
}]
...
