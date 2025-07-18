from setuptools import setup

import strix_theme_generator

setup(
    name="strix-theme-generator",
    version="1.0",
    # Modules to import from other scripts:
    packages=["strix_theme_generator"],
    entry_points={
        "console_scripts": ["strix-theme-generator=strix_theme_generator.__main__:main"]
    },
    install_requires=["colorz", "toml"],
)
