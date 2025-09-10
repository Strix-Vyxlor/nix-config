{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption optionals mkIf mkMerge;
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

  fontType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = ''
          name of font to use
        '';
      };
      package = mkOption {
        type = types.package;
        description = ''
          package name in nixpkgs
        '';
      };
    };
  };

  strToPkg = string: let
    filter = s: builtins.isString s;
    split = builtins.split "\\." string;
    parts = builtins.filter filter split;
  in
    lib.attrsets.getAttrFromPath parts pkgs;
in {
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
      font = {
        default = mkOption {
          type = fontType;
          default = {
            name =
              if useDefault
              then "Inter Regular"
              else theme.font.default.name;
            package =
              if useDefault
              then pkgs.inter
              else strToPkg theme.font.default.package;
          };
        };
        monospace = mkOption {
          type = fontType;
          default = {
            name =
              if useDefault
              then "Hack"
              else theme.font.monospace.name;
            package =
              if useDefault
              then pkgs.hack-font
              else strToPkg theme.font.monospace.package;
          };
        };
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

      fonts = {
        monospace = {
          name = cfg.font.monospace.name;
          package = cfg.font.monospace.package;
        };
        serif = {
          name = cfg.font.default.name;
          package = cfg.font.default.package;
        };
        sansSerif = {
          name = cfg.font.default.name;
          package = cfg.font.default.package;
        };
      };
    };

    terminal = {
      colors = {
        background = "#${config.lib.stylix.colors.base01}";
        foreground = "#${config.lib.stylix.colors.base05}";
        cursor = "#${config.lib.stylix.colors.base05}";
        color0 = "#${config.lib.stylix.colors.base00}";
        color1 = "#${config.lib.stylix.colors.base01}";
        color2 = "#${config.lib.stylix.colors.base02}";
        color3 = "#${config.lib.stylix.colors.base03}";
        color4 = "#${config.lib.stylix.colors.base04}";
        color5 = "#${config.lib.stylix.colors.base05}";
        color6 = "#${config.lib.stylix.colors.base06}";
        color7 = "#${config.lib.stylix.colors.base07}";
        color8 = "#${config.lib.stylix.colors.base08}";
        color9 = "#${config.lib.stylix.colors.base09}";
        color10 = "#${config.lib.stylix.colors.base0A}";
        color11 = "#${config.lib.stylix.colors.base0B}";
        color12 = "#${config.lib.stylix.colors.base0C}";
        color13 = "#${config.lib.stylix.colors.base0D}";
        color14 = "#${config.lib.stylix.colors.base0E}";
        color15 = "#${config.lib.stylix.colors.base0F}";
      };
    };
  };
}
