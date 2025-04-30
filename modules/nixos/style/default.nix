{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption mkIf mkMerge;
  cfg = config.strixos.style;
  themeCfg = cfg.stylix.theme;
  themeFile = themeCfg.themeDir + "/theme.toml";
  themeExtra = themeCfg.themeDir + "/theme.nix";
  imagePath = themeCfg.themeDir + "/background.png";
  themeImage =
    if (builtins.pathExists imagePath)
    then imagePath
    else null;
  theme = builtins.fromTOML (builtins.readFile themeFile);
in {
  imports = [
    ./def_apps.nix
  ];

  options.strixos.style = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable styling of applications
      '';
    };
    stylix = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          use stylix styling when available
        '';
      };
      theme = {
        themeDir = mkOption {
          type = types.nullOr types.path;
          default = null;
          description = ''
            directory containing theme (overides other options)
            directory structure:
              themeDir
              ├─ theme.toml (the theme)
              ├─ background.png (the background picture)
              ├─ home.nix (extra theme specific styling for home manager)
              └─ theme.nix (extra theme specific styling)
          '';
        };
        polarity = mkOption {
          type = types.enum [
            "either"
            "light"
            "dark"
          ];
          default =
            if themeCfg.themeDir == null
            then "either"
            else theme.polarity;
          description = ''
            the theme polarity
          '';
        };
        scheme = mkOption {
          type = types.oneOf [types.path types.lines types.attrs];
          default =
            if themeCfg.themeDir == null
            then "${pkgs.base16-schemes}/share/themes/colors.yaml"
            else theme.colors;
          description = ''
            base 16 yaml scheme to use
          '';
        };
        image = mkOption {
          type = types.nullOr types.path;
          default =
            if themeCfg.themeDir == null
            then null
            else themeImage;
          description = ''
            image to use as a background
          '';
        };
      };
    };
  };

  config =
    mkIf (cfg.enable && cfg.stylix.enable)
    (mkMerge [
      {
        stylix = {
          enable = true;
          autoEnable = false;
          inherit (themeCfg) polarity image;
          base16Scheme = themeCfg.scheme;
        };
      }
      (mkIf (builtins.pathExists themeExtra) {
        imports = [themeExtra];
      })
    ]);
}
