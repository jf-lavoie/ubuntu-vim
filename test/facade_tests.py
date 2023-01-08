import os
import sys

from install.facade import Facade

# allow import of package
sys.path.insert(0,
                os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# import install

# class TestFacadeInstall():

#     def test_links_flags_should_call_link_function(self):
#         f = new Facade()
#         f.install([])

# class TestInstallation():

#     def test_links_should_call_install_links(self):
