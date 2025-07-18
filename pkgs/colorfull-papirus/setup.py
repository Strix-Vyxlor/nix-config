from setuptools import setup

import colorfull_papirus

setup(
    name="colorfull-papirus",
    version="1.0",
    # Modules to import from other scripts:
    packages=["colorfull_papirus"],
    entry_points={
        "console_scripts": ["colorfull-papirus=colorfull_papirus.__main__:main"]
    },
)
