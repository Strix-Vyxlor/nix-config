{pkgs, lib, config, ...}:
let 
  inherit (lib) types mkOption mkIf mkMerge;
  cfg = config.strixos.boot;
in {
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
      ];);
      default = null;
      description = ''
        bootloader to use
      '';
    };
  };

  config = mkIf (cfg.loader != null) { 
 
      boot.loader.systemd-boot.enable = optional (cfg.loader == "systemd-boot") true;

  };
}
