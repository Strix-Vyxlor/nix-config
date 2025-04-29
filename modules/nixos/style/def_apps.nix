{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption mkIf;
  cfg = config.strixos.style.stylix.targets;
  styleCfg = config.strixos.style;
in {
  options.strixos.style.stylix.targets = {
    console = mkOption {
      type = types.bool;
      default = false;
      description = ''
        style the linux console;
      '';
    };
    nixos-icons = mkOption {
      type = types.bool;
      default = false;
      description = ''
        style the nixos-icons;
      '';
    };
  };

  config = mkIf (styleCfg.enable && styleCfg.stylix.enable) {
    stylix.targets = {
      console.enable = cfg.console;
      nixos-icons.enable = cfg.nixos-icons;
    };
  };
}
