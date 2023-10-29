import os
import sys
from unittest.mock import patch

# allow import of package
sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..',
                                    'install')))

import facade
import main

# print("jf-debug: " + str(sys.path))


@patch('facade.Facade')
def test_main_with_links_should_call_facade_install_with_link_true(facadeMock):

    testargs = ["--links"]

    with patch.object(sys, 'argv', testargs):
        assert facadeMock is facade.Facade

        main.main()

        assert facadeMock.called

        actualInstance = facadeMock.return_value
        assert actualInstance.install.called
