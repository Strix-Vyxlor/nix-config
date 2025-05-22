{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption mkIf mkMerge;
  cfg = config.strixos.style;
  useDefault = themeCfg.themeDir == null && themeCfg.generateWithImage == null;
  themeGenerator = image: (import ../../theme_generator.nix {
    inherit pkgs;
    imagePath = image;
  });
  themeCfg = cfg.theme;
  themeFile =
    if themeCfg.generateWithImage == null
    then themeCfg.themeDir + "/theme.toml"
    else (themeGenerator themeCfg.generateWithImage) + "/theme.toml";
  imagePath =
    if themeCfg.generateWithImage == null
    then themeCfg.themeDir + "/background.png"
    else themeCfg.generateWithImage;
  themeImage =
    if (builtins.pathExists imagePath)
    then imagePath
    else null;
  theme = builtins.fromTOML (builtins.readFile themeFile);
in {
  imports = [
    ./def_apps.nix
    ./desktop.nix
  ];

  options.strixos.style = {
    theme = {
      generateWithImage = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          when given path to an image, it wil try to generate
          a fitting theme with strix-theme-generator
        '';
      };

      themeDir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          directory containing theme (overides other options)
          directory structure:
            themeDir
            ├─ theme.toml (the theme)
            └─ background.png (the background picture)
        '';
      };
      polarity = mkOption {
        type = types.enum [
          "either"
          "light"
          "dark"
        ];
        default =
          if useDefault
          then "either"
          else theme.polarity;
        description = ''
          the theme polarity
        '';
      };
      scheme = mkOption {
        type = types.oneOf [types.path types.lines types.attrs];
        default =
          if useDefault
          then "${pkgs.base16-schemes}/share/themes/colors.yaml"
          else theme.colors;
        description = ''
          base 16 yaml scheme to use
        '';
      };
      image = mkOption {
        type = types.nullOr types.path;
        default =
          if useDefault
          then null
          else themeImage;
        description = ''
          image to use as a background
        '';
      };
    };
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = false;
      inherit (themeCfg) polarity image;
      base16Scheme = themeCfg.scheme;
      overlays.enable = true;
    };
  };
}
