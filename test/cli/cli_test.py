import os
import sys

# allow import of package
sys.path.insert(
    0,
    os.path.abspath(
        os.path.join(os.path.dirname(__file__), '..', '..', 'install')))

import cli


class TestParseArgs():

    def test_it_should_support_flag_links(self):
        args = cli.parse_args(['--links'])
        assert (args.links == True)
