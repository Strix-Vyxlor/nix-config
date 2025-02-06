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
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    ../../system/hardware/mesa.nix
    ../../system/hardware/time.nix
    ../../system/hardware/bluetooth.nix
    ../../system/style/stylix.nix
    (./. + "../../../system/wm" + ("/" + userSettings.wm) + ".nix")

    ../../system/security/doas.nix
    ../../system/security/gpg.nix

    ../../system/virt/podman.nix
  ];

  raspberry-pi-nix.board = "bcm2712";
  raspberry-pi-nix.uboot.enable = false;
  raspberry-pi-nix.kernel-version = "v6_10_12";
  raspberry-pi-nix.libcamera-overlay.enable = false;
  boot.initrd.systemd.tpm2.enable = false;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-substituters = [
      "https://anyrun.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-trusted-public-keys = [
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
    ];
  };
  nixpkgs.config.allowUnfree = true;

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
    extraGroups = ["networkmanager" "wheel" "input" "libvirtd" "plugdev"];
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

  hardware = {
    raspberry-pi = {
      config = {
        all = {
          options = {
            # The firmware will start our u-boot binary rather than a
            # linux kernel
            arm_64bit = {
              enable = true;
              value = true;
            };
            disable_overscan = {
              enable = true;
              value = true;
            };
          };
          dt-overlays = {
            vc4-kms-v3d = {
              enable = true;
              params = {};
            };
          };
          base-dt-params = {
            pciex1_gen = {
              enable = true;
              value = "3";
            };
          };
        };
      };
    };
  };
}
