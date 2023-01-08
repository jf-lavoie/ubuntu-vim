import os
import sys

# allow import of package
sys.path.insert(0,
                os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

import install


class TestParseArgs():

    def test_it_should_support_flag_links(self):
        args = install.parse_args(['--links'])
        assert (args.links == True)


class TestInstallation():

    def test_links_should_call_install_links(self):
