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

    (import ../../system/style/stylix.nix {
      inherit lib;
      inherit userSettings;
      plymouth = true;
    })
    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix")

    ../../system/security/doas.nix
    ../../system/security/gpg.nix
    ../../system/security/ssh.nix

    ../../system/virt/podman.nix
    ../../system/games/steam.nix
    ../../system/games/utils.nix
  ];

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  boot.plymouth.enable = true;
  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    # ....
  ];

  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

  services.avahi.enable = true;
  services.flatpak.enable = true;

  time.timeZone = systemSettings.timezone;
  i18n.defaultLocale = systemSettings.locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  programs.nix-ld.enable = true;

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
  ];

  fonts.fontDir.enable = true;
  #fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  fonts.packages = [pkgs.nerdfonts];

  console.keyMap = "be-latin1";

  system.stateVersion = "24.05";
}
