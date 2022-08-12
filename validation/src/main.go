package main

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"os"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/cuecontext"
	"cuelang.org/go/cue/errors"
	"cuelang.org/go/encoding/gocode/gocodec"
	"gopkg.in/yaml.v2"
)

type Model struct {
	Bgp struct {
		Asn        int    `yaml:"asn"`
		RouterID   string `yaml:"router_id"`
		Peergroups []struct {
			Name     string `yaml:"name"`
			RemoteAs string `yaml:"remote_as"`
		} `yaml:"peergroups"`
		Neighbors []struct {
			Interface  string `yaml:"interface"`
			Unnumbered bool   `yaml:"unnumbered"`
			Peergroup  string `yaml:"peergroup"`
		} `yaml:"neighbors"`
		AddressFamily []struct {
			Name         string `yaml:"name"`
			Redistribute []struct {
				Type string `yaml:"type"`
			} `yaml:"redistribute,omitempty"`
			Neighbors []struct {
				Interface string `yaml:"interface"`
				Activate  bool   `yaml:"activate"`
			} `yaml:"neighbors,omitempty"`
			AdvertiseAllVni bool `yaml:"advertise_all_vni,omitempty"`
		} `yaml:"address_family"`
		Vrfs []struct {
			Name          string `yaml:"name"`
			RouterID      string `yaml:"router_id"`
			AddressFamily []struct {
				Name         string `yaml:"name"`
				Redistribute []struct {
					Type string `yaml:"type"`
				} `yaml:"redistribute,omitempty"`
				Extras []string `yaml:"extras,omitempty"`
			} `yaml:"address_family"`
		} `yaml:"vrfs"`
	} `yaml:"bgp"`
}

// ModuleArgs are the module inputs
type ModuleArgs struct {
	Schema string
	Input  string
}

// Response are the values returned from the module
type Response struct {
	Msg     string `json:"msg"`
	Busy    bool   `json:"busy"`
	Changed bool   `json:"changed"`
	Failed  bool   `json:"failed"`
}

func ExitJSON(responseBody Response) {
	returnResponse(responseBody)
}

func FailJSON(responseBody Response) {
	responseBody.Failed = true
	returnResponse(responseBody)
}

func returnResponse(r Response) {
	var response []byte
	var err error
	response, err = json.Marshal(r)
	if err != nil {
		response, _ = json.Marshal(Response{Msg: "Invalid response object"})
	}
	fmt.Println(string(response))
	if r.Failed {
		os.Exit(1)
	}
	os.Exit(0)
}

func (r Response) check(err error, msg string) {
	if err != nil {
		r.Msg = msg + ": " + err.Error()
		FailJSON(r)
	}
}

func main() {
	var r Response

	if len(os.Args) != 2 {
		r.Msg = "No argument file provided"
		FailJSON(r)
	}

	argsFile := os.Args[1]

	text, err := os.ReadFile(argsFile)
	r.check(err, "Could not read configuration file: "+argsFile)

	var moduleArgs ModuleArgs
	err = json.Unmarshal(text, &moduleArgs)
	r.check(err, "Ansible inputs are not valid (JSON): "+argsFile)

	src, err := base64.StdEncoding.DecodeString(moduleArgs.Input)
	r.check(err, "Couldn't decode the configuration inputs file: "+moduleArgs.Input)
	reader := bytes.NewReader(src)

	d := yaml.NewDecoder(reader)

	var input Model
	err = d.Decode(&input)
	r.check(err, "Couldn't decode configuration inputs: "+string(src))

	c := cuecontext.New()
	schema, err := os.ReadFile(moduleArgs.Schema)
	r.check(err, "Could not read the schema file: "+moduleArgs.Schema)
	s := c.CompileString(string(schema))

	var runtime cue.Runtime
	codec := gocodec.New(&runtime, nil)
	v, err := codec.Decode(input)
	r.check(err, "Could not decode input as CUE values")

	iter, err := s.Fields([]cue.Option{
		cue.Definitions(false),
		cue.Docs(false),
		cue.Hidden(false),
	}...)
	r.check(err, "Could not create iterator for schema")

	// iterate over schema values and validate input variables
	for iter.Next() {
		inVal := v.LookupPath(cue.ParsePath(iter.Selector().String()))
		u := iter.Value().Unify(inVal)

		// check for errors during unification
		if u.Err() != nil {
			msg := errors.Details(u.Err(), nil)
			r.check(err, "Could unify input with CUE schema: "+msg)
		}

		// To get all errors, we need to validate
		if err := u.Validate(
			cue.Concrete(true),
		); err != nil {
			msg := errors.Details(err, nil)
			r.check(err, "Schema validation failed: "+msg)
		}
	}

	r.Msg = "Input data successfully validated"
	r.Changed = true
	r.Failed = false
	returnResponse(r)

}
