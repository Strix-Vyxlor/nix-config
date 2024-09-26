{
  config,
  lib,
  pkgs,
  zix-pkg,
  systemSettings,
  userSettings,
  inputs,
  ...
}: {
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
    backupFileExtension = ".hbk";
    useGlobalPkgs = true;

    config = ./home.nix;

    extraSpecialArgs = {
      inherit systemSettings;
      inherit userSettings;
      inherit inputs;
    };
  };

  android-integration = {
    termux-open.enable = true;
    termux-open-url.enable = true;
    termux-reload-settings.enable = true;
    termux-setup-storage.enable = true;
    termux-wake-lock.enable = true;
    termux-wake-unlock.enable = true;
    xdg-open.enable = true;
  };

  environment.motd = ''
    nix is crazy
  '';

  terminal = {
    colors = {
      background = "#1e1e2e";
      foreground = "#cdd6f4";
      cursor = "#cdd6f4";
      color0 = "#1e1e2e";
      color1 = "#f38ba8";
      color2 = "#a6e3a1";
      color3 = "#f9e2af";
      color4 = "#fab387";
      color5 = "#cba6f7";
      color6 = "#94e2d5";
      color7 = "#cdd6f4";
      color8 = "#45475a";
      color9 = "#f38ba8";
      color10 = "#a6e3a1";
      color11 = "#f9e2af";
      color12 = "#fab387";
      color13 = "#cba6f7";
      color14 = "#94e2d5";
      color15 = "#b4befe";
    };
    font = "${pkgs.nerdfonts}/share/fonts/truetype/NerdFonts/ZedMonoNerdFont-Regular.ttf";
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
  time.timeZone = systemSettings.timezone;
}
