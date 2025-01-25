# Tools for working with modern DreamMaker icon files (PNGs + metadata)

from .dmi import *

def transform(path):
    loaded: Dmi

    # todo: trycatch
    loaded = Dmi.from_file(path)
