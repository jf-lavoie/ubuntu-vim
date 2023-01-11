from pathlib import Path


def walkUpwards(until, path: str | Path) -> Path:
    p = Path(path)
    if p.parent == p:
        return p

    if until(p):
        return p

    return walkUpwards(until, p.parent)
