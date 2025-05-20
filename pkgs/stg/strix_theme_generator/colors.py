import colorz
from . import utils

def color_from_image(img):
    raw_colors = colorz.colorz(img, n=8, bold_add=0)
    return [utils.rgb_to_hex([*color[0]]) for color in raw_colors]

def gen_colors(img):
    img_colors = color_from_image(img)
    bg = utils.get_darkest(img_colors)
    fg = utils.get_lightest(img_colors)
    return [
            utils.darken_color(bg, .5),
            utils.darken_color(bg, .7),
            utils.darken_color(bg, .3),
            utils.lighten_color(bg, .2),
            utils.lighten_color(fg, .5),
            utils.lighten_color(fg, .7),
            utils.lighten_color(fg, .8),
            utils.lighten_color(bg, .6),
            *img_colors[:8],
            ]
    
