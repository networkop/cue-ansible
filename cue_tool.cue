package main

import (
	"tool/cli"
	"encoding/json"
	"encoding/base64"
	"strings"
	"tool/http"
	"tool/exec"
	"text/template"
	"tool/file"
)

device20: ["cumulus0", "cumulus1", "cumulus2", "cumulus3", "cumulus4", "cumulus5", "cumulus6", "cumulus7", "cumulus8", "cumulus9", "cumulus11", "cumulus12", "cumulus13", "cumulus14", "cumulus15", "cumulus16", "cumulus17", "cumulus18", "cumulus19", "cumulus20"]
device1: ["172.17.0.3"]
inventory: device1
username:  "cumulus"
password:  *"cumulus" | string @tag(password)
auth:      base64.Encode(null, "\(username):\(password)")

save: state: "apply"
save: "auto-prompt": ays:           "ays_yes"
save: "auto-prompt": "ignore_fail": "ignore_fail_yes"

command: apply: {
	for _, d in inventory {
		(d): {

			date: exec.Run & {
				cmd: ["date", "+%s"]
				stdout: string
			}

			create: http.Post & {
				url: "https://\(d):8765/nvue_v1/revision"
				tls: verify: false
				request: header: "Authorization": "Basic \(auth)"
			}

			revisionID: [ for k, v in json.Unmarshal(create.response.body) {k}]
			escapedID: strings.Replace(revisionID[0], "/", "%2F", -1)

			patch: http.Do & {
				method: "PATCH"
				url:    "https://\(d):8765/nvue_v1/?rev=\(escapedID)"
				tls: verify: false
				request: header: "Authorization": "Basic \(auth)"
				request: header: "Content-Type":  "application/json"
				request: body: json.Marshal(cvx & {system: message: "pre-login": strings.TrimSpace(date.stdout)})
			}

			print: cli.Print & {
				text: "PATCH RESPONSE: \(patch.response.body)"
			}

			apply: http.Do & {
				$after: patch
				method: "PATCH"
				url:    "https://\(d):8765/nvue_v1/revision/\(escapedID)"
				tls: verify: false
				request: header: "Authorization": "Basic \(auth)"
				request: header: "Content-Type":  "application/json"
				request: body: json.Marshal(save)
			}

			ok: cli.Print & {
				text: "APPLY RESPONSE \(apply.response.body)"
			}
		}
	}
}

command: ssh: {
	cli_template: file.Read & {
		filename: "cli_apply.tmpl"
		contents: string
	}

	for _, device in inventory {
		(device): {
			date: exec.Run & {
				cmd: ["date", "+%s"]
				stdout: string
			}

			cli_commands: template.Execute(cli_template.contents, {message: strings.TrimSpace(date.stdout)})

			dump: file.Create & {
				filename: "dump.txt"
				contents: cli_commands
			}

			apply: exec.Run & {
				cmd: ["sshpass", "-p", password, "ssh", "\(username)@\(device)", "bash", "-c", "'\(cli_commands)'"]
				stdout: string
				stderr: string
			}

			result: [
				if apply.success {
					"config applied"
				},
				if !apply.success {
					"apply failed!"
				},
			]

			print: cli.Print & {
				text: result[0]
			}

		}
	}
}

command: test: {
	date: exec.Run & {
		cmd: ["date", "+%s"]
		stdout: string
	}
	print: cli.Print & {
		text: json.Marshal(cvx & {system: message: "pre-login": strings.TrimSpace(date.stdout)})
	}
}
