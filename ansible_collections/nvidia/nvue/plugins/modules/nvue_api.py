#!/usr/bin/python

# Copyright: (c) 2022, NVIDIA <nvidia.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)


from __future__ import absolute_import, division, print_function

__metaclass__ = type


DOCUMENTATION = """"""
EXAMPLES = """"""
RETURN = """"""

from ansible.module_utils.basic import AnsibleModule
from ansible.module_utils.connection import Connection
from ansible.module_utils.six import string_types
from ansible.module_utils.common import yaml
from ansible_collections.ansible.netcommon.plugins.module_utils.network.common.utils import (
    dict_diff,
)


def main():
    """entry point for module execution"""
    module_args = {
        "operation": {
            "type": str,
            "choices": ["get", "set"],
            "default": "get",
        },
        "force": {"type": bool, "required": False, "default": False},
        "wait": {"type": int, "required": False, "default": 0},
        "path": {"type": str, "required": False, "default": "/"},
        "data": {"type": dict, "required": False, "default": {}},
    }

    required_if = [
        ["operation", "set", ["data"]],
    ]

    module = AnsibleModule(
        argument_spec=module_args,
        required_if=required_if,
        supports_check_mode=True,
    )

    path = module.params["path"]
    data = module.params["data"]
    operation = module.params["operation"]
    force = module.params["force"]
    wait = module.params["wait"]

    if isinstance(data, string_types):
        data = yaml.loads(data)

    warnings = list()
    result = {"changed": False, "warnings": warnings}

    running = None
    commit = not module.check_mode

    connection = Connection(module._socket_path)
    response = connection.send_request(data, path, operation, force=force, wait=wait)
    if operation=="set" and response:
        result["changed"] = True
    result["message"] = response

    module.exit_json(**result)


if __name__ == "__main__":
    main()
