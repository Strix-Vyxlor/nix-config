{ pkgs, lib, zix-pkg, systemSettings, userSettings, ... }:
{
  imports = [
    ../../system/hardware-configuration.nix
    ../../system/hardware/kernel.nix
    ../../system/hardware/mesa.nix
    ../../system/hardware/time.nix
    ../../system/hardware/bluetooth.nix

    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix")

    ../../system/security/doas.nix
    ../../system/security/gpg.nix
    ../../system/style/stylix.nix
  ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

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
    extraGroups = [ "networkmanager" "wheel" "input" ];
    packages = [];
    uid = 1000;
  };

  inputs.home-manager.backupFileExtension = "hkb";

  environment.systemPackages = with pkgs; [
    zix-pkg
    helix
    wget
    git
    home-manager
    wpa_supplicant
  ];

  fonts.fontDir.enable = true;

  system.stateVersion = "24.05";
}
