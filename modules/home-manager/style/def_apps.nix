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
  };

  config = mkIf styleCfg.enable {
    stylix.targets = {
      btop.enable = cfg.btop;
    };
  };
}
