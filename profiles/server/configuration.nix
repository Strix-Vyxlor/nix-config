{
  pkgs,
  lib,
  branch,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  strixos = {
    inherit branch;
    hostName = "strix-server";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
    };
    style.theme.themeDir = ../../themes/nord;
    boot = {
      loader = "systemd-boot";
    };
    network.avahi = true;
    locale = {
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
      consoleKeymap = "be-latin1";
    };
    hardware = {
      kernel = "lts";
    };
    programs = {
      superuser = "sudo";
      git = true;
    };
    services = {
      timesync = "chrony";
      tailscale = true;
      ssh.enable = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.k3s = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    kitty.terminfo
    helix
    wget
    git
    home-manager
  ];

  system.stateVersion = "25.05";
}
