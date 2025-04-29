{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption mkIf;
  cfg = config.strixos.boot;
in {
  imports = [
    ./plymouth.nix
  ];

  options.strixos.boot = {
    efiMountPoint = mkOption {
      type = types.str;
      default = "/boot";
      description = ''
        where to mount efi files
      '';
    };
    loader = mkOption {
      type = types.nullOr (types.enum [
        "systemd-boot"
      ]);
      default = null;
      description = ''
        bootloader to use
      '';
    };
  };

  config = mkIf (cfg.loader != null) {
    boot.loader = {
      systemd-boot.enable = cfg.loader == "systemd-boot";
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = cfg.efiMountPoint;
      };
    };
  };
}
