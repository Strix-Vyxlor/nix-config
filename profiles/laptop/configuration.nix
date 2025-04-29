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
    ../../system/hardware/kernel.nix
    ../../system/hardware/mesa.nix
    ../../system/hardware/time.nix
    ../../system/hardware/bluetooth.nix

    ../../system/hardware/udev.nix
    ../../system/hardware/tailscale.nix

    # ../../system/hardware/fingerprint.nix
    #../../system/hardware/kanata.nix

    ../../system/style/desktop.nix
    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix")

    ../../system/security/doas.nix
    ../../system/security/gpg.nix
    ../../system/security/ssh.nix

    ../../system/virt/podman.nix
    ../../system/games/steam/steam.nix
    ../../system/games/steam/gamescope-session.nix
    ../../system/games/steam/decky-loader.nix
  ];

  strixos = {
    inherit (systemSettings) branch hostName;
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
    style = {
      enable = true;
      stylix = {
        enable = true;
        theme.themeDir = ./. + "../../../themes" + ("/" + userSettings.theme);
        targets = {
          console = true;
          nixos-icons = true;
        };
      };
    };
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    sandbox = true
  '';
  nix.settings.sandbox = true;

  nix.settings = {
    extra-substituters = [
      "https://anyrun.cachix.org"
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
    substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    trusted-users = ["root" "@wheel"];
  };

  nixpkgs.config.allowUnfree = true;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
    # ....
  ];

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = ["networkmanager" "wheel" "input" "libvirtd"];
    packages = [];
    uid = 1000;
  };

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

  system.stateVersion = "24.11";
}
