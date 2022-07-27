from __future__ import absolute_import, division, print_function

__metaclass__ = type

import urllib

import json
import time

from ansible.module_utils.six.moves.urllib.error import HTTPError
from ansible_collections.ansible.netcommon.plugins.plugin_utils.httpapi_base import HttpApiBase


class HttpApi(HttpApiBase):
    def __init__(self, connection):
        super(HttpApi, self).__init__(connection)
        self.prefix = "/nvue_v1"
        self.headers = {"Content-Type": "application/json"}

    def send_request(self, data, path, operation, **kwargs):
        if operation == "set":
            return self.set_operation(data, path, **kwargs)
        elif operation == "get":
            params = {"rev": "applied"}
            path = f"{self.prefix}/?{urllib.parse.urlencode(params)}"
            return self.get_operation(path)


    def get_operation(self, path):
        response, response_data = self.connection.send(
            path, "", headers=self.headers, method="GET"
        )
        return handle_response(response, response_data)

    def set_operation(self, data, path, **kwargs):

        self.revisionID = self.create_revision()

        self.patch_revision(path, data)
        
        return self.apply_config(**kwargs)

    def create_revision(self):
        path = "/".join([self.prefix, "revision"])

        response, response_data = self.connection.send(
            path, dict(), method="POST", headers=self.headers
        )

        for k in handle_response(response, response_data):
            return k

    def patch_revision(self, path, data):
        
        params = {"rev": self.revisionID}
        path = f"{self.prefix}/?{urllib.parse.urlencode(params)}"

        response, response_data = self.connection.send(
            path, json.dumps(data), headers=self.headers, method="PATCH"
        )

        return handle_response(response, response_data)

    def apply_config(self, **kwargs):

        force=kwargs.get("force", False)
        wait=kwargs.get("wait", 0)
        path = "/".join([self.prefix, "revision", self.revisionID.replace("/", "%2F")])

        data = {"state": "apply"}
        if force:
            data["auto-prompt"] = {
                "ays": "ays_yes",
                "ignore_fail": "ignore_fail_yes",
            }

        response, response_data = self.connection.send(
            path,
            json.dumps(data),
            headers=self.headers,
            method="PATCH",
        )

        result = handle_response(response, response_data)

        for _ in range(wait):
            result = self.get_operation(path)
            if result.get("state") == "applied":
                break
            time.sleep(1)

        return result


def handle_response(response, response_data):
    try:
        response_data = json.loads(response_data.read())
    except ValueError:
        response_data.seek(0)
        response_data = response_data.read()

    if isinstance(response, HTTPError):
        raise Exception(f"Connection error: {response}, data: {response_data}")

    return response_data
