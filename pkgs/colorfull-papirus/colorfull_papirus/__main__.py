import sys
import argparse
import re
from . import utils
from . import writer

def get_args():
    args = argparse.ArgumentParser(description="modify Papirus icon theme to specific folder icon")

    args.add_argument("theme", type=str, help="path to theme folder")
    args.add_argument("foreground", type=str, help="main color")
    args.add_argument("-b", "--background", type=str,help="darker color to be used")
    args.add_argument("-i", "--icon", type=str, help="color for the black theme icon")
    args.add_argument("-p", "--paper", type=str, help="color to give thepaper")

    return args

def check_color(parser, color) -> str:
    m = re.match(r"^#[0-9A-Fa-f]{6}$", color)
    if m:
        return m.string 
    else:
        parser.error("Wrong color format given")



def parse_args(parser):
    args = parser.parse_args(); 

    if len(sys.argv) <= 2:
        parser.print_help()
        sys.exit(1)

    theme = args.theme
    fg = check_color(parser,args.foreground)
    if args.background == None:
        bg = utils.darken_color(fg, 0.2)
    else:
        bg = check_color(parser, args.background)

    if args.icon == None:
        icon = utils.lighten_color(fg, .6)
    else:
        icon = check_color(parser, args.icon)

    if args.paper == None:
        paper = utils.lighten_color(fg, .8)
    else:
        paper = check_color(parser, args.paper)

    writer.patch_black(theme, fg, bg, icon, paper)
    writer.patch_adwaita(theme, fg, bg, paper)
     
def main():
    parser = get_args()

    parse_args(parser)
    sys.exit(0)

if __name__ == "__main__":
    main()
