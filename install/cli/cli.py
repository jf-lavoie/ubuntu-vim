import argparse


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

    return parser.parse_known_args(args)[0]
