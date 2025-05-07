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
        type = types.str;
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
        type = types.str;
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
        type = types.str;
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
    font = mkOption {
      type = fontType;
      default = {
        name =
          if themeCfg.themeDir == null
          then "Inter Regular"
          else theme.font.name;
        package =
          if themeCfg.themeDir == null
          then "inter"
          else theme.font.package;
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
          then "papirus-icon-theme"
          else theme.icons.package;
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
          then "vimix-cursors"
          else theme.cursor.package;
        size =
          if themeCfg.themeDir == null
          then 24
          else theme.cursor.size;
      };
    };
  };

  config = mkIf cfg.enable (
    lib.throwIf (themeImage == null) ''
      for desktop styling you need to specify an image
    ''
    {
      stylix = {
        fonts = {
          monospace = {
            name = cfg.font.name;
            package = pkgs.${cfg.font.package};
          };
          serif = {
            name = cfg.font.name;
            package = pkgs.${cfg.font.package};
          };
          sansSerif = {
            name = cfg.font.name;
            package = pkgs.${cfg.font.package};
          };
        };
        cursor = {
          inherit (cfg.cursor) name size;
          #          package = pkgs.${cfg.cursor.package};
          package = pkgs.vimix-cursors;
        };
        iconTheme = {
          enable = true;
          package = pkgs.${cfg.icons.package};
          light = cfg.icons.name;
          dark = cfg.icons.name;
        };
        target = {
          gtk.enable = true;
          qt.enable = true;
        };
      };

      fonts.fontconfig.defaultFonts = {
        monospace = [cfg.font.name];
        sansSerif = [cfg.font.name];
        serif = [cfg.font.name];
      };
    }
  );
}
