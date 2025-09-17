import dmi
import glob
from PIL import Image

def black_to_transparent(globstr: str):
    for path in glob.iglob(globstr):
        dmi.transform(path).for_each_state(lambda s: black_to_transparent_state(s)).commit()
        print(path)

def black_to_transparent_state(state: dmi.State):
    state.frames = [black_to_transparent_image(f) for f in state.frames]
    return state

def black_to_transparent_image(image: Image.Image):
    image = image.copy()
    for x in range(image.width):
        for y in range(image.height):
            (r, g, b, a) = image.getpixel((x, y))
            if r == 0 and g == 0 and b == 0 and a == 255:
                image.putpixel((x, y), (0, 0, 0, 0))
    return image
