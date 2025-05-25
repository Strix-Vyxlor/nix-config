import glob
import os
from . import utils

sizes = ["22x22", "24x24", "32x32", "48x48", "64x64"]

def get_files(path, variant):
    files = []
    print(f"searching for {variant} in {path}")
    for size in sizes:
        root = f"{path}/{size}/places"
        for file in glob.glob(f"folder-{variant}*.svg", root_dir=root):
            full_file = f"{root}/{file}"
            if os.path.isfile(full_file) and not os.path.islink(full_file):
                files.append(full_file)
        for file in glob.glob(f"user-{variant}*.svg", root_dir=root):
            full_file = f"{root}/{file}"
            if os.path.isfile(full_file) and not os.path.islink(full_file):
                files.append(full_file)

    return files
        


def patch_black(path, fg, bg, icon, paper):
    files = get_files(path, "black") 

    for file in files:
        data = utils.read_file(file)

        data = data.replace("#3f3f3f", bg)
        data = data.replace("#4f4f4f", fg)
        data = data.replace("#c2c2c2", icon)
        data = data.replace("#dcdcdc", paper)

        utils.write_file(file,data)

def patch_adwaita(path, fg, bg, paper):
    files = get_files(path, "adwaita") 

    for file in files:
        data = utils.read_file(file)

        data = data.replace("#3a87e5", bg)
        data = data.replace("#93c0ea", fg)
        data = data.replace("#e4e4e4", paper)

        utils.write_file(file,data)

