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
      background = "#${config.lib.stylix.colors.base01}";
      foreground = "#${config.lib.stylix.colors.base05}";
      cursor = "#${config.lib.stylix.colors.base05}";
      color0 = "#${config.lib.stylix.colors.base00}";
      color1 = "#${config.lib.stylix.colors.base01}";
      color2 = "#${config.lib.stylix.colors.base02}";
      color3 = "#${config.lib.stylix.colors.base03}";
      color4 = "#${config.lib.stylix.colors.base04}";
      color5 = "#${config.lib.stylix.colors.base05}";
      color6 = "#${config.lib.stylix.colors.base06}";
      color7 = "#${config.lib.stylix.colors.base07}";
      color8 = "#${config.lib.stylix.colors.base08}";
      color9 = "#${config.lib.stylix.colors.base09}";
      color10 = "#${config.lib.stylix.colors.base0A}";
      color11 = "#${config.lib.stylix.colors.base0B}";
      color12 = "#${config.lib.stylix.colors.base0C}";
      color13 = "#${config.lib.stylix.colors.base0D}";
      color14 = "#${config.lib.stylix.colors.base0E}";
      color15 = "#${config.lib.stylix.colors.base0F}";
    };
    font = "${pkgs.nerdfonts.zed-mono}/share/fonts/truetype/NerdFonts/ZedMonoNerdFont-Regular.ttf";
  };

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".sbk";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = systemSettings.timezone;
}
