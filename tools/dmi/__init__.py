# Tools for working with modern DreamMaker icon files (PNGs + metadata)

from .codec import dmi

def load_dmi(path):
    return dmi.Dmi.from_file(path)
