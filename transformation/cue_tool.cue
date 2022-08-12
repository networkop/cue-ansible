package main

import (
	"encoding/json"
	"tool/file"
)

inventory: #inventory

command: "transform": {
	for _, device in inventory {
		(device): {

			save: file.Create & {
				filename: "./out/\(device).json"
				contents: json.Marshal(config[device])
			}
		}
	}
}
