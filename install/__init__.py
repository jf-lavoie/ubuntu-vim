import argparse
import sys

from .facade import Facade


def parse_args(args):
    parser = argparse.ArgumentParser(
        prog='Install',
        description='Installation of nvim and related tooling.',
        epilog='copyright 2023')

    parser.add_argument('--version', action='version', version="v1.0")

    parser.add_argument(
        '--links',
        '-l',
        action='store_true',
        help='Create the symlinks from nvim configuration to the git repository'
    )

    return parser.parse_args(args)


def main():
    args = parse_args(sys.argv)
    f = Facade()
    print(
        '(from main) jf-debug-> "f.install": {value}'.format(value=f.install))
    print('jf-debug-> "f": ' + ", ".join(dir(f)))
    print('jf-debug-> "f.install": ' + ", ".join(dir(f.install)))
    f.install(**vars(args))
    print('jf-debug-> "f.install.called": {value}'.format(
        value=f.install.called))


if __name__ == '__main__':
    main()
