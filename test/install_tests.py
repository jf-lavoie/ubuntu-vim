import os
import sys

# allow import of package
sys.path.insert(0,
                os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from unittest.mock import patch

import install


@patch('install.Facade', autospec=True)
def test_main_with_links_should_call_facade_install_with_link_true(facadeMock):
    install.main()

    assert facadeMock.called

    assert facadeMock.install is install.Facade.install

    assert facadeMock.install.called
