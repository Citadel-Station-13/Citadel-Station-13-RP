import PIL
import PIL.ImageOps

from .dmi import *
from .dmi_state import *

class DmiTransformPipeline:
    dmi: Dmi
    path: str
    committed: bool = False

    def __init__(self, dmi: Dmi, path: str):
        self.dmi = dmi
        self.path = path

    def greyscale_all_states(self):
        # todo: customizable lum's
        LUM_R = 0.213
        LUM_G = 0.715
        LUM_B = 0.072

        for state in self.dmi.states:
            self._greyscale_state(state)

    def greyscale_state(self, name: str):
        # todo: customizable lum's
        LUM_R = 0.213
        LUM_G = 0.715
        LUM_B = 0.072

        found: State = None
        for state in self.dmi.states:
            if state.name == name:
                found = state

        if not found:
            raise Exception("cannot find state with name {}".format(name))

        self._greyscale_state(found)

    def _greyscale_state(state: State):
        state.frames = [PIL.ImageOps.grayscale(f) for f in state.frames]


    def commit(self):
        if self.commited:
            raise Exception("dmi pipeline already committed.")
        self.dmi.to_file(self.path)
