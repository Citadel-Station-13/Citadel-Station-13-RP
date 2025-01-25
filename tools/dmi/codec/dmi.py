from PIL import Image
from PIL.PngImagePlugin import PngInfo

import math

from .constants import *
from .dirs import *
from .helpers import *
from .state import *

class Dmi:
    version = "4.0"

    def __init__(self, width, height):
        self.width = width
        self.height = height
        self.states = []

    @classmethod
    def from_file(cls, fname):
        image = Image.open(fname)
        if image.mode != 'RGBA':
            image = image.convert('RGBA')

        # no metadata = regular image file
        if 'Description' not in image.info:
            dmi = Dmi(*image.size)
            state = dmi.state("")
            state.frame(image)
            return dmi

        # read metadata
        metadata = image.info['Description']
        line_iter = iter(metadata.splitlines())
        assert next(line_iter) == "# BEGIN DMI"
        assert next(line_iter) == f"version = {cls.version}"

        dmi = Dmi(*DMI_DEFAULT_SIZE)
        state = None

        for line in line_iter:
            if line == "# END DMI":
                break
            key, value = line.lstrip().split(" = ")
            if key == 'width':
                dmi.width = int(value)
            elif key == 'height':
                dmi.height = int(value)
            elif key == 'state':
                state = dmi.state(unescape(value))
            elif key == 'dirs':
                state.dirs = int(value)
            elif key == 'frames':
                state._nframes = int(value)
            elif key == 'delay':
                state.delays = [parse_num(x) for x in value.split(',')]
            elif key == 'loop':
                state.loop = int(value)
            elif key == 'rewind':
                state.rewind = parse_bool(value)
            elif key == 'hotspot':
                x, y, frm = [int(x) for x in value.split(',')]
                state.hotspot(frm - 1, x, y)
            elif key == 'movement':
                state.movement = parse_bool(value)
            else:
                raise NotImplementedError(key)

        # cut image into frames
        width, height = image.size
        gridwidth = width // dmi.width
        i = 0
        for state in dmi.states:
            for frame in range(state._nframes):
                for dir in range(state.dirs):
                    px = dmi.width * (i % gridwidth)
                    py = dmi.height * (i // gridwidth)
                    im = image.crop((px, py, px + dmi.width, py + dmi.height))
                    assert im.size == (dmi.width, dmi.height)
                    state.frames.append(im)
                    i += 1
            state._nframes = None

        return dmi

    def state(self, *args, **kwargs):
        s = State(self, *args, **kwargs)
        self.states.append(s)
        return s

    @property
    def default_state(self):
        return self.states[0]

    def get_state(self, name):
        for state in self.states:
            if state.name == name:
                return state
        raise KeyError(name)

    def _assemble_comment(self):
        comment = "# BEGIN DMI\n"
        comment += f"version = {self.version}\n"
        comment += f"\twidth = {self.width}\n"
        comment += f"\theight = {self.height}\n"
        for state in self.states:
            comment += f"state = {escape(state.name)}\n"
            comment += f"\tdirs = {state.dirs}\n"
            comment += f"\tframes = {state.framecount}\n"
            if state.framecount > 1 and len(state.delays):  # any(x != 1 for x in state.delays):
                comment += "\tdelay = " + ",".join(map(str, state.delays)) + "\n"
            if state.loop != 0:
                comment += f"\tloop = {state.loop}\n"
            if state.rewind:
                comment += "\trewind = 1\n"
            if state.movement:
                comment += "\tmovement = 1\n"
            if state.hotspots and any(state.hotspots):
                current = None
                for i, value in enumerate(state.hotspots):
                    if value != current:
                        x, y = value
                        comment += f"\thotspot = {x},{y},{i + 1}\n"
                        current = value
        comment += "# END DMI"
        return comment

    def to_file(self, filename, *, palette=False):
        # assemble comment
        comment = self._assemble_comment()

        # assemble spritesheet
        W, H = self.width, self.height
        num_frames = sum(len(state.frames) for state in self.states)
        sqrt = math.ceil(math.sqrt(num_frames))
        output = Image.new('RGBA', (sqrt * W, math.ceil(num_frames / sqrt) * H))

        i = 0
        for state in self.states:
            for frame in state.frames:
                output.paste(frame, ((i % sqrt) * W, (i // sqrt) * H))
                i += 1

        # save
        pnginfo = PngInfo()
        pnginfo.add_text('Description', comment, zip=True)
        if palette:
            output = output.convert('P')
        output.save(filename, 'png', optimize=True, pnginfo=pnginfo)

    def swap_ns(self):
        for i in range(0, len(self.states)):
            state = self.states[i]
            state.swap_ns()

    def swap_ew(self):
        for i in range(0, len(self.states)):
            state = self.states[i]
            state.swap_ew()
