import toml

def write_toml(output, font, monospace, cursor, icons, colors, light):
    data = {
            "polarity": "dark" if light else "light",
            "font": {
                "default":  font,
                "monospace": monospace,
                     },
            "cursor": cursor,
            "icons": icons,
            "colors": {
                "base00": colors[0],
                "base01": colors[1],
                "base02": colors[2],
                "base03": colors[3],
                "base04": colors[4],
                "base05": colors[5],
                "base06": colors[6],
                "base07": colors[7],
                "base08": colors[8],
                "base09": colors[9],
                "base0A": colors[10],
                "base0B": colors[11],
                "base0C": colors[12],
                "base0D": colors[13],
                "base0E": colors[14],
                "base0F": colors[15],
                },
            }
    with open(output, "w+") as f:
        toml.dump(data, f)
