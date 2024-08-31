{config, lib, pkgs, zix-pkg, systemSettings, userSettings, inputs, ... }:
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
      color4 = "#89b4fa";
      color3 = "#f9e2af";
      color2 = "#a6e3a1";
      color5 = "#94e2d5";
      color6 = "#fab387";
      color7 = "#cba6f7";
      color8 = "#45475a";
      color9 = "#f38ba8";
      color12 = "#89b4fa";
      color11 = "#f9e2af";
      color10 = "#a6e3a1";
      color13 = "#94e2d5";
      color14 = "#fab387";
      color15 = "#cba6f7";
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
