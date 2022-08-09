package main

import (
	"log"
	"os"

	"cuelang.org/go/cue"
	"cuelang.org/go/cue/format"
	"cuelang.org/go/encoding/json"
	"cuelang.org/go/encoding/jsonschema"
)

func main() {
	log.Print(len(os.Args))
	if len(os.Args) != 2 {
		log.Fatal("Expecting exactly one argument")
	}

	outputFileName := os.Args[1]
	inputFileName := "schema.json"
	inputData, err := os.ReadFile(inputFileName)
	if err != nil {
		log.Fatal(err)
	}

	r := &cue.Runtime{}
	in, err := json.Decode(r, inputFileName, inputData)
	if err != nil {
		log.Fatal(err)
	}

	cfg := &jsonschema.Config{ID: "schema.json", PkgName: "schema"}
	expr, err := jsonschema.Extract(in, cfg)
	if err != nil {
		log.Fatal(err)
	}
	b, err := format.Node(expr, format.Simplify())
	if err := os.WriteFile(outputFileName, b, 0644); err != nil {
		log.Fatal(err)
	}

}
