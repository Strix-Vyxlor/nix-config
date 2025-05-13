{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.terminal.kitty;
  styleCfg = config.strixos.style;
  hyprCfg = config.strixos.desktop.hyprland;

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
          the font package
        '';
      };
      size = mkOption {
        type = types.int;
        description = ''
          font size to use
        '';
      };
    };
  };
in {
  options.strixos.programs.terminal.kitty = {
    enable = mkOption {
      type = types.bool;
      default = hyprCfg.enable && (hyprCfg.apps.terminal == "kitty");
      description = ''
        enable kitty terminal emulator
      '';
    };
    font = mkOption {
      type = fontType;
      default = {
        name = "MesloLG NF";
        package = pkgs.nerd-fonts.meslo-lg;
        size = 12;
      };
      description = ''
        the font to use and install
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      settings = {
        font_family = cfg.font.name;
        font_size = cfg.font.size;
        cursor_shape = "block";
        background_opacity = lib.mkForce 0.75;

        shell = "${config.lib.strixos.shell.package}/bin/${config.lib.strixos.shell.command}";
      };
    };

    home.packages = [cfg.font.package];

    stylix.targets.kitty = {
      enable = true;
      variant256Colors = true;
    };
  };
}
