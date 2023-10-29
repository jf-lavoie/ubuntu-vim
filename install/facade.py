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

    def _unique(self, l):
        output = []
        for x in l:
            if x not in output:
                output.append(x)
        return output

    def _links(self):

        files = [
            (root, "", "init.lua"),
            (root, "", "vim-jfsnippets"),
            (root, "", "ftplugin"),
        ]

        for (dir_path, _, file_names) in walk(path.join(root, "lua")):
            files = files + list(
                map(lambda f:
                    (root, dir_path.partition(root)[2][1:], f), file_names))

        dirs_to_create = self._unique(
            list(filter(None, map(lambda f: f[1], files))))

        for d in dirs_to_create:
            subprocess.run([
                "mkdir", "-p",
                path.join(os.environ["INSTALL_VI_ROOTPATH"], d)
            ])

        for f in files:
            args = [
                "ln", "-sfv",
                path.join(f[0], f[1], f[2]),
                path.join(os.environ["INSTALL_VI_ROOTPATH"], f[1], f[2])
            ]
            subprocess.run(args)
