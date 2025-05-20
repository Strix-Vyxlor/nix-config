def parse_cursor(s: str, parser):
    parts = s.split(';')
    if len(parts) != 3:
        parser.error("Wrong icons format.\n"
                     "--cursor, -c take the form of <name>;<package name>;<cursor size>")

    return {
            "name": parts[0],
            "package": parts[1],
            "size": int(parts[2]),
            }
