import os
import subprocess
from os import path, walk

# from install import fs

root = path.abspath(path.join(path.dirname(__file__), '..'))


class Facade(object):
    """
    Entry point for installation of nvim
    """

    def install(self, links=False):

        if links:
            self._links()

    def _links(self):

        files = [
            (root, "init.lua"),
            (root, "vim-jfsnippets"),
        ]

        for (dir_path, _, file_names) in walk(path.join(root, "lua")):
            files = files + list(map(lambda f: (dir_path, f), file_names))

        for f in files:
            subprocess.run([
                "ln", "-sfv",
                path.join(os.environ["INSTALL_VI_ROOTPATH"], f[1]),
                path.join(f[0], f[1])
            ])
