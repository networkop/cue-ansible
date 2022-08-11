package main

import (
	"tool/cli"
	"tool/exec"
	"encoding/json"
	"tool/http"
	"encoding/base64"
	"strings"

)

device1: ["172.17.0.3"]
inventory: device1
//username:  "admin"
//password:  *"admin" | string @tag(password)
username: "root"
password: "root"
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

command: "test-eos": {

	for _, device in inventory {
		(device): {
			cli_commands: exec.Run & {
				cmd: ["j2", "-f", "json", "arista/template-trimmed.j2", "-"]
				stdin:  json.Marshal(arista)
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

command: "apply-eos": {

	for _, device in inventory {
		(device): {
			commands: exec.Run & {
				cmd: ["j2", "-f", "json", "template-trimmed.j2", "-"]
				stdin:  json.Marshal(arista)
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

#frr_wrapper: {
	input: [...string]
	output: ["'configure'"] + input + ["'end'"] + ["'write'"]
}

command: "test-frr": {

	for _, device in inventory {
		(device): {
			cli_commands: exec.Run & {
				cmd: ["j2", "-f", "json", "frr/frr.j2", "-"]
				stdin:  json.Marshal(nvidia)
				stdout: string
			}
			split_commands: strings.Split(cli_commands.stdout, "\n")

			wrapped_commands: #frr_wrapper & {input: split_commands}

			print: cli.Print & {
				text: strings.Join(wrapped_commands.output, "\n")
			}

		}
	}
}

command: "apply-frr": {

	for _, device in inventory {
		(device): {
			cli_commands: exec.Run & {
				cmd: ["j2", "-f", "json", "frr/frr.j2", "-"]
				stdin:  json.Marshal(nvidia)
				stdout: string
			}
			#split: strings.Split(cli_commands.stdout, "\n")

			split_commands: [ for x in #split if x != "", if x != "!", if x != " !" {"\"\(x)\""}]

			wrapped_commands: #frr_wrapper & {input: split_commands}

			script: strings.Join(wrapped_commands.output, " -c ")

			apply: exec.Run & {
				cmd: ["sshpass", "-p", password, "ssh", "\(username)@\(device)", "vtysh", "-c", "\(script)"]
				stdout: string
				stderr: string
			}

		}
	}
}