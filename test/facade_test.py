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
                (root, "init.lua"),
                (root, "vim-jfsnippets"),
            ]

            for (dir_path, _, file_names) in walk(path.join(root, "lua")):
                expectedLinkedFiles = expectedLinkedFiles + list(
                    map(lambda f: (dir_path, f), file_names))

            assert mock.call_count == len(expectedLinkedFiles)
            for f in expectedLinkedFiles:
                mock.assert_any_call([
                    "ln", "-sfv",
                    path.join(self.install_path, f[1]),
                    path.join(f[0], f[1])
                ])
