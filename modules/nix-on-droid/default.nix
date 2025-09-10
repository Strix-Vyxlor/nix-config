inputs: {
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption;
  cfg = config.strixos;
in {
  imports = [
    ./programs
    ../overlay.nix
  ];
  options.strixos = {
    branch = mkOption {
      type = types.enum [
        "stable"
        "unstable"
      ];
      default = "stable";
      description = ''
        branch of nixpkgs
      '';
    };
    timezone = mkOption {
      type = types.nullOr (types.str);
      default = null;
      description = ''
        timezone to use
      '';
    };
  };

  config = {
    environment.packages = with pkgs; [
      # Some common stuff that people expect to have
      procps
      killall
      diffutils
      findutils
      utillinux
      tzdata
      hostname
      man
      gnugrep
      gnupg
      gnused
      gnutar
      bzip2
      gzip
      xz
      zip
      unzip
      nettools
      coreutils
      git
    ];
    android-integration = {
      termux-open.enable = true;
      termux-open-url.enable = true;
      termux-reload-settings.enable = true;
      termux-setup-storage.enable = true;
      termux-wake-lock.enable = true;
      termux-wake-unlock.enable = true;
      xdg-open.enable = true;
    };
    time.timeZone = cfg.timeZone;
    environment.etcBackupExtension = ".sbk";
  };
}
