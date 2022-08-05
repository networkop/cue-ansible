#!/usr/bin/env python3
from jinja2schema import infer
from jinja2schema import to_json_schema
import json
import sys
import os

def main():
    if len(sys.argv) != 2: 
        print("expected exactly one argument")
        sys.exit(1)
    input_filename = sys.argv[1]
    f = open("template-trimmed.j2", "r")
    schema = to_json_schema(infer(f.read()))
    f = open("schema.json", "a")
    f.write(json.dumps(schema, indent=2))
    f.close()


if __name__ == "__main__":
    main()