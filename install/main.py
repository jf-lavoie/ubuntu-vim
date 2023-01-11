import sys

import cli
# from install import facade
import facade


def main():
    args = cli.parse_args(sys.argv)

    f = facade.Facade()
    f.install(**vars(args))


if __name__ == '__main__':
    main()
