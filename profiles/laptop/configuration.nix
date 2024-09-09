{ pkgs, lib, zix-pkg, systemSettings, userSettings, ... }:
{
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

    ../../system/style/stylix.nix
    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix")

    ../../system/security/doas.nix
    ../../system/security/gpg.nix

    ../../system/virt/virt.nix
    ../../system/games/steam.nix
  ];
 
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };
  boot.plymouth.enable = true;

  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;

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

  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" ];
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

  console.keyMap = "be-latin1";

  system.stateVersion = "24.05";
}
