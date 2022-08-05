package main

import (
	"tool/cli"
	"tool/exec"
	"encoding/json"
	"tool/http"
	"encoding/base64"
	"strings"

)

device1: ["172.20.20.2"]
inventory: device1
username:  "admin"
password:  *"admin" | string @tag(password)
auth:      base64.Encode(null, "\(username):\(password)")

jsonrpc_body: {
	jsonrpc: "2.0"
	method:  "runCmds"
	params: {
		version: 1
		cmds: [...string]
	}
}

#eapi_wrapper: {
	input: [...string]
	output: ["enable", "configure"] + input + ["write"]
}

command: test: {

	for _, device in inventory {
		(device): {
			cli_commands: exec.Run & {
				cmd: ["j2", "-f", "json", "template-trimmed.j2", "-"]
				stdin:  json.Marshal(config)
				stdout: string
			}
			split_commands: strings.Split(cli_commands.stdout, "\n")

			wrapped_commands: #eapi_wrapper & {input: split_commands}

			print: cli.Print & {
				text: strings.Join(wrapped_commands.output, "\n")
			}
		}
	}
}

command: apply: {

	for _, device in inventory {
		(device): {
			commands: exec.Run & {
				cmd: ["j2", "-f", "json", "template-trimmed.j2", "-"]
				stdin:  json.Marshal(config)
				stdout: string
			}

			#split: strings.Split(commands.stdout, "\n")

			split_commands: [ for x in #split if x != "" {x}]

			wrapped_commands: #eapi_wrapper & {input: split_commands}

			create: http.Post & {
				url: "https://\(device):443/command-api"
				tls: verify: false
				request: {
					header: "Authorization": "Basic \(auth)"
					body: json.Marshal(jsonrpc_body & {
						params: cmds: wrapped_commands.output
						id: device
					})
				}
			}
			response: cli.Print & {
				text: "CREATE RESPONSE \(create.response.body)"
			}
		}
	}
}
