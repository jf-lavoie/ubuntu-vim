import os
import sys
from pathlib import Path

# allow import of package
sys.path.insert(
    0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..',
                                    'install')))

import fs


def test_should_return_parent_directory():
    cwd = os.getcwd()
    parent = Path(cwd).parent
    output = fs.walkUpwards(lambda x: x == parent, cwd)
    assert parent == output


def test_should_return_itself_if_root():
    output = fs.walkUpwards(lambda x: x == "/", "/")
    assert Path("/") == output


def test_should_return_Path_object_even_when_given_a_string():
    cwd = os.getcwd()
    parent = Path(cwd).parent
    output = fs.walkUpwards(lambda x: x == str(parent), str(cwd))
    assert isinstance(output, Path)
