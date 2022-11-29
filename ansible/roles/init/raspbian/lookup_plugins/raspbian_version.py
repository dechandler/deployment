from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

# DOCUMENTATION = """
#     lookup: raspbian_version
#     author: David Chandler <contact@dechandler.io>
#     version_added: "0.1"
#     short_description: get latest raspbian lite version
#     description:
#         - This lookup returns the timestamp of the latest raspbian lite version available
# """
import requests

from ansible.errors import AnsibleError, AnsibleParserError
from ansible.plugins.lookup import LookupBase
from ansible.module_utils._text import to_text


try:
    from __main__ import display
except ImportError:
    from ansible.utils.display import Display
    display = Display()


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):

        latest_url = "https://downloads.raspberrypi.org/raspbian_lite_latest"
        r = requests.get(latest_url, allow_redirects=False)
        location = r.headers.get('location')
        version = location.split('/')[-1].split('-')[:3]
        return [to_text('-'.join(version))]
