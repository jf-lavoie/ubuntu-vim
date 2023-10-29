import sys
from os import path, walk
from unittest.mock import MagicMock, patch

# allow import of package
root = path.abspath(path.join(path.dirname(__file__), '..'))
sys.path.insert(0, path.join(root, 'install'))

import facade


class TestFacadeInstallLinks():

    args = {'links': True}
    install_path = '$HOME/.config/nvim'

    @patch.dict('os.environ', {"INSTALL_VI_ROOTPATH": install_path})
    def test_should_link_files(self):
        with patch('facade.subprocess.run') as mock:

            mock_stdout = MagicMock()
            mock_stdout.configure_mock(**{"stdout": '{"A": 3}'})

            mock.return_value = mock_stdout
            f = facade.Facade()
            f.install(**self.args)

            expectedLinkedFiles = [
                (root, "", "init.lua"),
                (root, "", "vim-jfsnippets"),
                (root, "", "ftplugin"),
            ]

            for (dir_path, _, file_names) in walk(path.join(root, "lua")):
                expectedLinkedFiles = expectedLinkedFiles + list(
                    map(lambda f: (root, dir_path.partition(root)[2][1:], f),
                        file_names))

            mock.assert_any_call(
                ["mkdir", "-p",
                 path.join(self.install_path, "lua/jf")])

            for f in expectedLinkedFiles:
                mock.assert_any_call([
                    "ln", "-sfv",
                    path.join(f[0], f[1], f[2]),
                    path.join(self.install_path, f[1], f[2])
                ])

            assert mock.call_count == len(expectedLinkedFiles) + 1
