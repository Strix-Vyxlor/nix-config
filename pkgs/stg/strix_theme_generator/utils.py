
def hex_to_rgb(color):
    return tuple(bytes.fromhex(color.strip("#")))


def rgb_to_hex(color):
    return "#%02x%02x%02x" % (*color,)


def darken_color(color, amount):
    color = [int(col * (1 - amount)) for col in hex_to_rgb(color)]
    return rgb_to_hex(color)

def lighten_color(color, amount):
    color = [int(col + (255 - col) * amount) for col in hex_to_rgb(color)]
    return rgb_to_hex(color)

def blend_color(color, color2):
    r1, g1, b1 = hex_to_rgb(color)
    r2, g2, b2 = hex_to_rgb(color2)

    r3 = int(0.5 * r1 + 0.5 * r2)
    g3 = int(0.5 * g1 + 0.5 * g2)
    b3 = int(0.5 * b1 + 0.5 * b2)

    return rgb_to_hex((r3, g3, b3))

def get_lightest(colors):
    luminance = []
    for color in colors:
        color_r, color_g, color_b = hex_to_rgb(color)
        L = (3 * color_r + 10 * color_g + color_b) // 14
        luminance.append(L)
    m = max(luminance)
    return colors[luminance.index(m)]

def get_darkest(colors):
    luminance = []
    for color in colors:
        color_r, color_g, color_b = hex_to_rgb(color)
        L = (3 * color_r + 10 * color_g + color_b) // 14
        luminance.append(L)
    m = min(luminance)
    return colors[luminance.index(m)]
 

