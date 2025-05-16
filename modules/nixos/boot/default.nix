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
    ./rpi5.nix
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
        "rpi5"
      ]);
      default = null;
      description = ''
        bootloader to use
      '';
    };
    maxGenerations = mkOption {
      type = types.nullOr types.int;
      default = 10;
      description = ''
        maximum amountof generations in bootloader
      '';
    };
  };

  config = mkIf (cfg.loader != null || cfg.loader != "rpi5") {
    boot.loader = {
      grub.enable = false;
      systemd-boot = {
        enable = cfg.loader == "systemd-boot";
        configurationLimit = cfg.maxGenerations;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = cfg.efiMountPoint;
      };
    };
  };
}
