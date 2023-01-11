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

    def _unique(self, list: list[str]) -> list[str]:
        output = []
        for x in list:
            if x not in output:
                output.append(x)
        return output

    def _links(self):

        files = [
            (root, "", "init.lua"),
            (root, "", "vim-jfsnippets"),
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

        # print('jf-debug-> "files": {value}'.format(value=files))
        for f in files:
            args = [
                "ln", "-sfv",
                path.join(f[0], f[1], f[2]),
                path.join(os.environ["INSTALL_VI_ROOTPATH"], f[1], f[2])
            ]
            # print('jf-debug-> "f": {value}'.format(value=f))
            # print('jf-debug-> "args": {value}'.format(value=args))
            # print('jf-debug-> "os.environ["INSTALL_VI_ROOTPATH"]": {value}'.
            #       format(value=os.environ["INSTALL_VI_ROOTPATH"]))
            # print(
            #     'jf-debug-> "path.join(os.environ["INSTALL_VI_ROOTPATH"], f[1], f[2])": {value}'
            #     .format(value=path.join(os.environ["INSTALL_VI_ROOTPATH"],
            #                             f[1], f[2])))
            # print('jf-debug-> "os.environ["INSTALL_VI_ROOTPATH"]": {value}'.
            #       format(value=os.environ["INSTALL_VI_ROOTPATH"]))
            subprocess.run(args)
