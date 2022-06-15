#!/usr/bin/python
# -*- coding: utf-8 -*-

# Copyright: (c) 2022, networkop <mkashin@nvidia.com>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)

# Original design: https://github.com/ansible-collections/community.network/blob/main/plugins/modules/network/cumulus/nclu.py

from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = r'''
---
module: nvue_base

short_description: Run NVUE commands on Nvidia Cumulus Linux

# If this is part of a collection, you need to use semantic versioning,
# i.e. the version is of the form "2.5.0" and not "2.4".
version_added: "1.0.0"

description: This is my longer description explaining my test module.

options:
    commands:
        description: A list of strings containing the net commands to run. Mutually exclusive with _template_.
        required: false
        type: list
    apply:
        description: When true, performs a ‘nvue apply’ at the end of the block.
        required: false
        default: true
        type: bool
    ignore_errors:
        description: When true, adds a ‘-y’ flag to the ‘nvue apply’ command.
        required: false
        type: bool
# Specify this value according to your collection
# in format of namespace.collection.doc_fragment_name
extends_documentation_fragment:
    - my_namespace.my_collection.my_doc_fragment_name

author:
    - Michael Kashin (@networkop)
'''

EXAMPLES = r'''
# Pass in a message
- name: Test with a message
  my_namespace.my_collection.my_test:
    name: hello world

# pass in a message and have changed true
- name: Test with a message and changed output
  my_namespace.my_collection.my_test:
    name: hello world
    new: true

# fail the module
- name: Test failure of the module
  my_namespace.my_collection.my_test:
    name: fail me
'''

RETURN = r'''
# These are examples of possible return values, and in general should use other names for return values.
original_message:
    description: The original name param that was passed in.
    type: str
    returned: always
    sample: 'hello world'
message:
    description: The output message that the test module generates.
    type: str
    returned: always
    sample: 'goodbye'
'''

from ansible.module_utils.basic import AnsibleModule

def run_nvue_cmd(module, command, errmsg=None):
    """Run a command, catch any nvue errors"""
    (_rc, output, _err) = module.run_command("/usr/bin/nv %s" % command)
    if module.params.get('ignore_errors'):
        return str(output)
    if _rc or 'error' in output.lower() or 'error' in _err.lower():
        msg=errmsg if errmsg else output
        module.fail_json(msg=msg, debug=output)
    return str(output)

def run_nvue(module):
    changed = False

    commands = []

    cmds = module.params.get('commands')
    if len(cmds) > 0:
        commands = cmds
    # elif render template

    output_lines = []

    for line in commands:
        if line.strip():
            output_lines += [run_nvue_cmd(module, line.strip(), "Failed on line \"%s\"" % line)]
    
    output = "\n".join(output_lines)

    diff = {}
    # TODO: add diff implementation

    apply_cmd = "config apply"
    abort_cmd = "config detach"
    apply = module.params.get('apply')
    if module.params.get('ignore_errors'):
        apply_cmd += " --assume-yes"

    if apply:
        result = run_nvue_cmd(module, apply_cmd)
        if "ignore" in result.lower():
            changed = False
            run_nvue_cmd(module, abort_cmd)


    return changed, output, diff


def run_module():
    # define available arguments/parameters a user can pass to the module
    module_args = dict(
        commands=dict(type='list', required=False),
        apply=dict(type='bool', required=False, default=True),
        ignore_errors=dict(type='bool', required=False, default=False),
        save=dict(type='bool', required=False, default=False)
    )

    # seed the result dict in the object
    # we primarily care about changed and state
    # changed is if this module effectively modified the target
    # state will include any data that you want your module to pass back
    # for consumption, for example, in a subsequent task
    result = dict(
        changed=False,
        original_message='',
        message=''
    )

    # the AnsibleModule object will be our abstraction working with Ansible
    # this includes instantiation, a couple of common attr would be the
    # args/params passed to the execution, as well as if the module
    # supports check mode
    module = AnsibleModule(
        argument_spec=module_args,
        supports_check_mode=True
    )

    # if the user is working with this module in only check mode we do not
    # want to make any changes to the environment, just return the current
    # state with no modifications
    if module.check_mode:
        module_args['apply'] = False
        module.exit_json(**result)

    changed, output, diff = run_nvue(module)

    # manipulate or modify the state as needed (this is going to be the
    # part where your module will do what it needs to do)
    #result['original_message'] = module.params['name']
    result['message'] = output
    result['diff'] = diff

    # use whatever logic you need to determine whether or not this module
    # made any modifications to your target
    #if module.params['new']:
    #    result['changed'] = changed

    # during the execution of the module, if there is an exception or a
    # conditional state that effectively causes a failure, run
    # AnsibleModule.fail_json() to pass in the message and the result
    #if module.params['name'] == 'fail me':
    #    module.fail_json(msg='You requested this to fail', **result)

    # in the event of a successful module execution, you will want to
    # simple AnsibleModule.exit_json(), passing the key/value results
    module.exit_json(**result)


def main():
    run_module()


if __name__ == '__main__':
    main()