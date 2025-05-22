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
    btop = mkOption {
      type = types.bool;
      default = false;
      description = ''
        style btop
      '';
    };
    nixos-icons = mkOption {
      type = types.bool;
      default = true;
      description = ''
        style nixos icons
      '';
    };
  };

  config = {
    stylix.targets = {
      btop.enable = cfg.btop;
      nixos-icons.enable = cfg.nixos-icons;
    };
  };
}
