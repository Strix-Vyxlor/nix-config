{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.desktop.displayManager;
in {
  imports = [
    ./regreet.nix
  ];
  options.strixos.desktop.displayManager = {
    displayManager = mkOption {
      type = types.nullOr (types.enum [
        "ly"
        "regreet"
      ]);
      default = null;
      description = ''
        display manager to use
      '';
    };
    lySettings = mkOption {
      type = types.attrs;
      default = {
        clock = "%I:%M:%S %p\n%A %d %B";
        bigclock = true;
        clear_password = true;
        animation = "matrix";
        cmatrix_fg = "0x06";
      };
      description = ''
        ly settings file contents
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg.displayManager == "ly") {
      services.displayManager.ly = {
        enable = true;
        settings = cfg.lySettings;
      };
    })
  ];
}
