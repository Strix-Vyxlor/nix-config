def parse_package(s: str, parser):
    parts = s.split(';')
    if len(parts) != 2:
        parser.error("Wrong package format.\n"
                     "--icons, --font, --monoscpace, -i, -f, -m take the form of <name>;<package name>")

    return {
            "name": parts[0],
            "package": parts[1],
            }
