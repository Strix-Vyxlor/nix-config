{
  pkgs,
  lib,
  branch,
  ...
}: {
  imports = [
    ../../system/hardware-configuration.nix
  ];
  strixos = {
    inherit branch;
    hostName = "pix";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
    };
    boot = {
      loader = "rpi5";
    };
    hardware = {
      kernel = "rpi5";
    };
    network = {
      manager = "network-manager";
      avahi = true;
    };
    locale = {
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
      consoleKeyap = "be-latin1";
    };
    programs = {
      superuser = "doas";
      git = true;
    };
    services = {
      timesync = "chrony";
      ssh.enable = true;
    };
    style.theme.themeDir = ../../themes/nord;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    helix
    wget
    git
    home-manager
  ];

  system.stateVersion = "25.05";
}
