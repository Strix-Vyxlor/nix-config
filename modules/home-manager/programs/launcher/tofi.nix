{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.strixos.programs.launcher.tofi;
  hyprCfg = config.strixos.desktop.hyprland;
  styleCfg = config.strixos.style;
in {
  options.strixos.programs.launcher.tofi = mkOption {
    type = types.bool;
    default = hyprCfg.enable && (hyprCfg.apps.launcher == "tofi");
    description = ''
      enable tofi launcher
    '';
  };

  config = mkIf cfg {
    programs.tofi = {
      enable = true;
      settings = {
        font = "${styleCfg.desktop.font.default.name}";
        font-size = 16;

        corner-radius = 30;
        width = 500;
        height = 300;

        prompt-color = "#${config.lib.stylix.colors.base05}";
        prompt-background = "#${config.lib.stylix.colors.base00}";
        prompt-background-padding = "5, 7";
        prompt-background-corner-radius = 13;

        input-color = "#${config.lib.stylix.colors.base05}";
        input-background = "#${config.lib.stylix.colors.base00}";
        input-background-padding = "5, 0";

        selection-color = "#${config.lib.stylix.colors.base0E}";
        selection-background = "#${config.lib.stylix.colors.base02}";
        selection-background-padding = "2, 5";
        selection-background-corner-radius = 13;

        default-result-color = "#${config.lib.stylix.colors.base05}";
        default-result-background-corner-radius = 13;

        alternate-result-color = "#${config.lib.stylix.colors.base07}";
        alternate-result-background = "#${config.lib.stylix.colors.base01}";
        alternate-result-background-padding = "0, 5";
        alternate-result-background-corner-radius = 13;

        border-color = "#${config.lib.stylix.colors.base0D}";
        outline-width = 0;
        background-color = "#${config.lib.stylix.colors.base00}";
      };
    };
  };
}
