from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

# DOCUMENTATION = """
#       lookup: img_mount_offset
#         author: David Chandler <contact@dechandler.io>
#         version_added: "0.1"
#         short_description: get partition offsets for img file
#         description:
#             - This lookup returns the contents from a file on the Ansible controller's file system.
#         options:
#           _terms:
#             description: path(s) of files to get partition offsets of
#             required: True
# """
import subprocess

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

        results = []
        for image_file in terms:
            cmd = ["fdisk", "-l", image_file]
            process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
            out, err = process.communicate()
            out = out.splitlines()
            offsets = []
            parts = False
            for l in out:
                if l.startswith(b"Units:"):
                    units = int(l.split()[7])
                elif l.startswith(b"Device"):
                    parts = True
                    continue
                if parts:
                    offsets.append(int(l.split()[1]) * units)
            results.append(offsets)
        return results