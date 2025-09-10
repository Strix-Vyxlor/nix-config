import argparse
import sys

from .colors import gen_colors
from .export import write_toml
from .icons import parse_cursor
from .package import parse_package


def get_args():
    arg = argparse.ArgumentParser(description="generate theme.toml from wallpaper")

    arg.add_argument("image", type=str, help="path to image to get colors from")
    arg.add_argument(
        "-f",
        "--font",
        default="Inter Regular;inter",
        help="font name and package name seperated with ; (default: %(default)s",
    )
    arg.add_argument(
        "-m",
        "--monospace",
        default="MesloLg NF;nerd-fonts.meslo-lg",
        help="monospace font name and package name seperated with ; (default: %(default)s",
    )
    arg.add_argument(
        "-c",
        "--cursor",
        default="Vimix-cursors;vimix-cursors;24",
        help="cursor name, package name and size seperated with ; (default: %(default)s",
    )
    arg.add_argument(
        "-i",
        "--icons",
        default="Papirus-Dark;papirus-icon-theme",
        help="icons name and package name seperated with ; (default: %(default)s",
    )
    arg.add_argument(
        "-b",
        "--bg-color",
        default="#131313",
        help="the background color (default: %(default)s",
    )
    arg.add_argument(
        "-F",
        "--fg-color",
        default="#FAFAFA",
        help="the background color (default: %(default)s",
    )
    arg.add_argument(
        "-l", "--light", action="store_false", help="create a light theme."
    )
    arg.add_argument(
        "-o", "--output", default="theme.toml", help="create a light theme."
    )

    return arg


def parse_args(parser):
    args = parser.parse_args()

    if len(sys.argv) <= 1:
        parser.print_help()
        sys.exit(1)

    cursor = parse_cursor(args.cursor, parser)
    icons = parse_package(args.icons, parser)
    font = parse_package(args.font, parser)
    monospace = parse_package(args.monospace, parser)
    colors = gen_colors(args.image)

    write_toml(args.output, font, monospace, cursor, icons, colors, args.light)


def main():
    parser = get_args()

    parse_args(parser)
    sys.exit(0)


if __name__ == "__main__":
    main()
