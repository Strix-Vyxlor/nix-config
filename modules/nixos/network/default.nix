{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption mkMerge mkIf;
  cfg = config.strixos.network;
  userCfg = config.strixos.user;
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

  config = mkMerge [
    {
      networking.networkmanager.enable = cfg.manager == "network-manager";

      services.avahi.enable = cfg.avahi;
    }
    (mkIf (userCfg.username != null) {
      users.users.${userCfg.username}.extraGroups = ["networkmanager"];
    })
  ];
}
