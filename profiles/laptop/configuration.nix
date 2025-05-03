{
  pkgs,
  lib,
  zix-pkg,
  systemSettings,
  userSettings,
  inputs,
  ...
}: {
  imports = [
    ../../system/hardware-configuration.nix

    ../../system/games/steam/steam.nix
    ../../system/games/steam/gamescope-session.nix
    ../../system/games/steam/decky-loader.nix
  ];

  strixos = {
    inherit (systemSettings) branch hostName;
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      extraGroups = ["input"];
    };
    boot = {
      loader = "systemd-boot";
      plymouth = {
        enable = true;
        style = true;
      };
    };
    network = {
      manager = "network-manager";
      avahi = true;
    };
    locale = {
      inherit (systemSettings) timezone locale;
      consoleKeymap = "be-latin1";
    };
    hardware = {
      kernel = "testing";
      graphics = true;
      bluetooth = true;
      tlp = true;

      platformioCompat = true;
    };
    programs = {
      superuser = "doas";
      git = true;
    };
    services = {
      timesync = "timesyncd";
      tailscale = true;
      ssh.enable = true;
      pipewire = true;
      rtkit = true;
      dbus = true;
    };
    desktop = {
      hyprland = {
        enable = true;
        xkb = {
          layout = "be";
          variant = "";
          options = "";
        };
        nautilus = true;
        keyring = "gnome-keyring";
      };
      displayManager.displayManager = "ly";
    };
    style = {
      enable = true;
      theme.themeDir = ./. + "../../../themes" + ("/" + userSettings.theme);
      targets = {
        console = true;
        nixos-icons = true;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  environment.systemPackages = with pkgs; [
    zix-pkg
    helix
    wget
    git
    home-manager
    wpa_supplicant
    brightnessctl
  ];

  fonts.fontDir.enable = true;
  fonts.packages = [pkgs.nerd-fonts.zed-mono pkgs.nerd-fonts.hack];

  system.stateVersion = "25.05";
}
