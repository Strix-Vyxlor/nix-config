{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption mkIf;
  cfg = config.strixos.style.targets;
  styleCfg = config.strixos.style;
in {
  options.strixos.style.targets = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        style apps
      '';
    };
    console = mkOption {
      type = types.bool;
      default = cfg.enable;
      description = ''
        style the linux console;
      '';
    };
    nixos-icons = mkOption {
      type = types.bool;
      default = cfg.enable;
      description = ''
        style the nixos-icons;
      '';
    };
  };

  config = {
    stylix.targets = {
      console.enable = cfg.console;
      nixos-icons.enable = cfg.nixos-icons;
    };
  };
}
