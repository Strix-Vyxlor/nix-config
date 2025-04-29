{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.strixos.network;
in {
  options.strixos.network = {
    manager = mkOption {
      type = types.nullOr (types.enum [
        "network-manager"
      ]);
      default = null;
      description = ''
        program to manage network;
      '';
    };
    avahi = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable avahi daemon (hostname broadcasting)
      '';
    };
  };

  config = {
    networking.networkmanager.enable = cfg.manager == "network-manager";

    services.avahi.enable = cfg.avahi;
  };
}
