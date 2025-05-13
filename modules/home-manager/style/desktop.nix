{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption mkIf mkMerge;
  cfg = config.strixos.style.desktop;

  themeCfg = config.strixos.style.theme;
  themeFile = themeCfg.themeDir + "/theme.toml";
  imagePath = themeCfg.themeDir + "/background.png";
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

  iconsType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = ''
          name of icon theme
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

  cursorType = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = ''
          name of cursor theme
        '';
      };
      package = mkOption {
        type = types.package;
        description = ''
          package name in nixpkgs
        '';
      };
      size = mkOption {
        type = types.int;
        description = ''
          size of cursor
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
  options.strixos.style.desktop = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable styling of desktop applications
        (qt, gtk)
      '';
    };
    font = {
      default = mkOption {
        type = fontType;
        default = {
          name =
            if themeCfg.themeDir == null
            then "Inter Regular"
            else theme.font.default.name;
          package =
            if themeCfg.themeDir == null
            then pkgs.inter
            else strToPkg theme.font.default.package;
        };
      };
      monospace = mkOption {
        type = fontType;
        default = {
          name =
            if themeCfg.themeDir == null
            then "Hack"
            else theme.font.monospace.name;
          package =
            if themeCfg.themeDir == null
            then pkgs.hack-font
            else strToPkg theme.font.monospace.package;
        };
      };
    };
    icons = mkOption {
      type = iconsType;
      default = {
        name =
          if themeCfg.themeDir == null
          then "Papirus"
          else theme.icons.name;
        package =
          if themeCfg.themeDir == null
          then pkgs.papirus-icon-theme
          else strToPkg theme.icons.package;
      };
    };
    cursor = mkOption {
      type = cursorType;
      default = {
        name =
          if themeCfg.themeDir == null
          then "Vimix-cursors"
          else theme.cursor.name;
        package =
          if themeCfg.themeDir == null
          then pkgs.vimix-cursors
          else strToPkg theme.cursor.package;
        size =
          if themeCfg.themeDir == null
          then 24
          else theme.cursor.size;
      };
    };
  };

  config =
    mkIf cfg.enable
    {
      stylix = {
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
        cursor = {
          inherit (cfg.cursor) name size;
          package = cfg.cursor.package;
        };
        iconTheme = {
          enable = true;
          package = cfg.icons.package;
          light = cfg.icons.name;
          dark = cfg.icons.name;
        };
        targets = {
          gtk.enable = true;
          qt.enable = true;
        };
      };

      fonts.fontconfig.defaultFonts = {
        monospace = [cfg.font.monospace.name];
        sansSerif = [cfg.font.default.name];
        serif = [cfg.font.default.name];
      };
    };
}
