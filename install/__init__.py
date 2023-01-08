from .facade import Facade


def main():
    f = Facade()
    f.install()
    print('jf-debug-> "f.install.called": {value}'.format(
        value=f.install.called))
