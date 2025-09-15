# Tools for working with modern DreamMaker icon files (PNGs + metadata)

import colorsys
import math
import re

from PIL import Image
from PIL.PngImagePlugin import PngInfo
import PIL.PngImagePlugin

# Header #

class Dmi:
    pass
class State:
    pass
class DmiTransformPipeline:
    pass

# Public #

def transform(path):
    loaded: Dmi

    # todo: trycatch
    loaded = Dmi.from_file(path)

    return DmiTransformPipeline(loaded, path)

def load(path):
    return Dmi.from_file(path)

# Constants #

NORTH = 1
SOUTH = 2
EAST = 4
WEST = 8
SOUTHEAST = SOUTH | EAST
SOUTHWEST = SOUTH | WEST
NORTHEAST = NORTH | EAST
NORTHWEST = NORTH | WEST

CARDINALS = [NORTH, SOUTH, EAST, WEST]

DIR_ORDER = [SOUTH, NORTH, EAST, WEST, SOUTHEAST, SOUTHWEST, NORTHEAST, NORTHWEST]
DIR_NAMES = {
    'SOUTH': SOUTH,
    'NORTH': NORTH,
    'EAST': EAST,
    'WEST': WEST,
    'SOUTHEAST': SOUTHEAST,
    'SOUTHWEST': SOUTHWEST,
    'NORTHEAST': NORTHEAST,
    'NORTHWEST': NORTHWEST,
    **{str(x): x for x in DIR_ORDER},
    **{x: x for x in DIR_ORDER},
    '0': SOUTH,
    None: SOUTH,
}

DEFAULT_SIZE = 32, 32

# Helpers #

def escape(text):
    text = text.replace('\\', '\\\\')
    text = text.replace('"', '\\"')
    return f'"{text}"'


def unescape(text, quote='"'):
    if text == 'null':
        return None
    if not (text.startswith(quote) and text.endswith(quote)):
        raise ValueError(text)
    text = text[1:-1]
    text = text.replace('\\"', '"')
    text = text.replace('\\\\', '\\')
    return text


def parse_num(value):
    if '.' in value:
        return float(value)
    return int(value)


def parse_bool(value):
    if value not in ('0', '1'):
        raise ValueError(value)
    return value == '1'

# State #

class State:
    dmi: Dmi
    name: str
    # number for times, None for infinite
    loop: int | None
    rewind: bool
    movement: bool
    dirs: int
    frames: list[Image.Image]
    delays: list[int]
    hotspots: list[(int, int)]

    def __init__(self, dmi, name, *, loop=None, rewind=False, movement=False, dirs=1):
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

# DMI #

class Dmi:
    version = "4.0"

    width: int
    height: int
    states: list[State]

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

        dmi = Dmi(*DEFAULT_SIZE)
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
                state.rewind = True
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

        # DEBUG
        dmi._metadata = metadata

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
            if state.loop != None:
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

# Transform Pipeline #

class DmiTransformPipeline:
    dmi: Dmi
    path: str
    committed: bool = False

    def __init__(self, dmi: Dmi, path: str):
        self.dmi = dmi
        self.path = path

    def lighten_state_pattern(self, pattern: str, ratio: float) -> DmiTransformPipeline:
        matcher: re.Pattern = re.compile(pattern)
        self.dmi.states = [DmiTransformPipeline._lighten_state(s, ratio) if matcher.fullmatch(s.name) else s for s in self.dmi.states]
        return self

    def lighten_state(self, name: str | list[str], ratio: float) -> DmiTransformPipeline:
        if type(name) == "str":
            self.dmi.states = [DmiTransformPipeline._lighten_state(s, ratio) if s.name == name else s for s in self.dmi.states]
        else:
            self.dmi.states = [DmiTransformPipeline._lighten_state(s, ratio) if s.name in name else s for s in self.dmi.states]
        return self

    def _lighten_state(state: State, ratio: float) -> State:
        state.frames = [DmiTransformPipeline._lighten_image(f, ratio) for f in state.frames]
        return state

    '''
    Lightens an image. This is not in-place.
    Accepts a ratio of 'distance to white' to change.
    Ratio may be -1 to 1.
    '''
    def _lighten_image(image: Image.Image, ratio: float) -> Image.Image:
        if(ratio == 0):
            return image.copy()
        if(ratio > 1 or ratio < -1):
            raise ValueError("Ratio is not within bounds.")

        image = image.copy()

        # todo: use np, make this fast
        for x in range(image.width):
            for y in range(image.height):
                (r, g, b, a) = image.getpixel((x, y))
                (h, s, v) = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
                v = v + (1 - v) * ratio if ratio > 0 else v * (1 + ratio)
                (r, g, b) = colorsys.hsv_to_rgb(h, s, v)
                image.putpixel((x, y), (round(r * 255), round(g * 255), round(b * 255), a))

        return image

    def greyscale_state_pattern(self, pattern: str) -> DmiTransformPipeline:
        matcher: re.Pattern = re.compile(pattern)
        self.dmi.states = [DmiTransformPipeline._greyscale_state(s) if matcher.fullmatch(s.name) else s for s in self.dmi.states]
        return self

    def greyscale_all_states(self) -> DmiTransformPipeline:

        for state in self.dmi.states:
            DmiTransformPipeline._greyscale_state(state)

        return self

    def greyscale_state(self, name: str | list[str]) -> DmiTransformPipeline:
        if type(name) == "str":
            self.dmi.states = [DmiTransformPipeline._greyscale_state(s) if s.name == name else s for s in self.dmi.states]
        else:
            self.dmi.states = [DmiTransformPipeline._greyscale_state(s) if s.name in name else s for s in self.dmi.states]
        return self

    def _greyscale_state(state: State) -> State:
        state.frames = [DmiTransformPipeline._greyscale_image(f) for f in state.frames]
        return state

    '''
    Greyscales an image. This is not in-place.
    '''
    def _greyscale_image(image: Image.Image) -> Image.Image:
        # todo: customizable lum's
        LUM_R = 0.213
        LUM_G = 0.715
        LUM_B = 0.072

        image = image.copy()

        # todo: use np, make this fast
        for x in range(image.width):
            for y in range(image.height):
                (r, g, b, a) = image.getpixel((x, y))
                image.putpixel((x, y), (
                    int(r * LUM_R + g * LUM_G + b * LUM_B),
                    int(r * LUM_R + g * LUM_G + b * LUM_B),
                    int(r * LUM_R + g * LUM_G + b * LUM_B),
                    a,
                ))

        return image

    def for_each_state(self, f):
        self.dmi.states = [f(s) for s in self.dmi.states]
        return self

    def for_each_state_pattern(self, pattern: str, f):
        matcher: re.Pattern = re.compile(pattern)
        self.dmi.states = [f(s) if matcher.fullmatch(s.name) else s for s in self.dmi.states]
        return self

    def commit(self):
        if self.committed:
            raise Exception("dmi pipeline already committed.")
        self.dmi.to_file(self.path)
