from PIL import Image

from .dmi_constants import *
from .dmi_helpers import *
from .dmi import *

class State:
    dmi: Dmi
    name: str
    loop: int
    rewind: bool
    movement: bool
    dirs: int
    frames: list[Image.Image]
    delays: list[int]
    hotspots: list[(int, int)]

    def __init__(self, dmi, name, *, loop=LOOP_ONCE, rewind=False, movement=False, dirs=1):
        self.dmi = dmi
        self.name = name
        self.loop = loop
        self.rewind = rewind
        self.movement = movement
        self.dirs = dirs

        self._nframes = None  # used during loading only
        self.frames = []
        self.delays = []
        self.hotspots = None

    @property
    def framecount(self):
        if self._nframes is not None:
            return self._nframes
        else:
            return len(self.frames) // self.dirs

    def frame(self, image, *, delay=1):
        assert image.size == (self.dmi.width, self.dmi.height)
        self.delays.append(delay)
        self.frames.append(image)

    def hotspot(self, first_frame, x, y):
        if self.hotspots is None:
            self.hotspots = [None] * self.framecount
        for i in range(first_frame, self.framecount):
            self.hotspots[i] = x, y

    def _frame_index(self, frame=0, dir=None):
        ofs = DIR_ORDER.index(DIR_NAMES[dir])
        if ofs >= self.dirs:
            ofs = 0
        return frame * self.dirs + ofs

    def get_frame(self, *args, **kwargs):
        return self.frames[self._frame_index(*args, **kwargs)]

    def swap_ns(self):
        for i in range(0, self.framecount):
            if len(self.frames) <= i * self.dirs + 1:
                continue
            # south
            f1 = (i * self.dirs) + 0
            # north
            f2 = (i * self.dirs) + 1
            # swap
            buffer = self.frames[f1]
            self.frames[f1] = self.frames[f2]
            self.frames[f2] = buffer

    def swap_ew(self):
        for i in range(0, self.framecount):
            if len(self.frames) <= i * self.dirs + 3:
                continue
            # east
            f1 = (i * self.dirs) + 2
            # west
            f2 = (i * self.dirs) + 3
            # swap
            buffer = self.frames[f1]
            self.frames[f1] = self.frames[f2]
            self.frames[f2] = buffer
