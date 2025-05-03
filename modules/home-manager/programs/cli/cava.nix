{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.cli.cava;
in {
  options.strixos.programs.cli.cava = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable cava
      '';
    };
    style = mkOption {
      type = types.bool;
      default = false;
      description = ''
        style cava
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.cava.enable = true;
    }
    (mkIf (cfg.style && config.strixos.style.enable) {
      programs.cava.settings = {
        color = {
          gradient = 1;
          gradient_color_1 = "'#${config.lib.stylix.colors.base08}'";
          gradient_color_2 = "'#${config.lib.stylix.colors.base09}'";
          gradient_color_3 = "'#${config.lib.stylix.colors.base0A}'";
          gradient_color_4 = "'#${config.lib.stylix.colors.base0B}'";
          gradient_color_5 = "'#${config.lib.stylix.colors.base0C}'";
          gradient_color_6 = "'#${config.lib.stylix.colors.base0D}'";
          gradient_color_7 = "'#${config.lib.stylix.colors.base0E}'";
          gradient_color_8 = "'#${config.lib.stylix.colors.base0F}'";
        };
      };
    })
  ]);
}
