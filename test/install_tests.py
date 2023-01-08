import os
import sys

# from install import facade

# allow import of package
sys.path.insert(0,
                os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from unittest.mock import patch

import install


class TestParseArgs():

    def test_it_should_support_flag_links(self):
        args = install.parse_args(['--links'])
        assert (args.links == True)


@patch('install.Facade')
def test_main_with_links_should_call_facade_install_with_link_true(facadeMock):

    testargs = ["--links"]

    with patch.object(sys, 'argv', testargs):
        install.main()

        assert facadeMock is install.Facade
        print('jf-debug-> "facadeMock": {value}'.format(value=facadeMock))

        assert facadeMock.called

        assert facadeMock.install is install.Facade.install
        print('jf-debug-> "facadeMock.install": {value}'.format(
            value=facadeMock.install))

        print('jf-debug-> "facadeMock.install.called": {value}'.format(
            value=facadeMock.install.called))
        assert facadeMock.install.called

        facadeMock.install.assert_called_once_with(links=True)


# @patch('install.Facade.install')
# def test_main_with_links_should_call_facade_install_with_link_true(facadeMock):

#     testargs = ["--links"]

#     with patch.object(sys, 'argv', testargs):
#         install.main()

#         assert facadeMock is install.Facade.install

#         assert facadeMock.called

#         facadeMock.assert_called_once_with(links=True)
