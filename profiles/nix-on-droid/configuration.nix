{ config, lib, pkgs, zix-pkg, systemSettings, userSettings, inputs, ... }:
{
  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    helix # or some other editor, e.g. nano or neovim
    zix-pkg
        
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

  home-manager = {
    backupFileExtension = ".hm-back";
    useGlobalPkgs = true;

    config = ./home.nix;

    extraSpecialArgs = {
      inherit systemSettings;
      inherit userSettings;
      inherit inputs;
    };
  };

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = systemSettings.timeZone;
}
