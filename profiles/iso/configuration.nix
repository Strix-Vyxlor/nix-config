{
  pkgs,
  lib,
  config,
  modulesPath,
  branch,
  ...
}: {
  users.users.nixos.initialHashedPassword = lib.mkForce "$y$j9T$ITDkLHgDnoG6RjFRXP5ta.$VE28HESr/J8UHW.YOUbkUnWx..4Zmnu/WZSibJ4j630";
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  strixos = {
    inherit branch;
    locale = {
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
      consoleKeymap = "be-latin1";
    };
    services.ssh = {
      enable = true;
      rootPassword = true;
    };
    style.targets.enable = false;
  };

  environment.systemPackages = with pkgs; [
    helix
    curl
    zip
    unzip
    ccrypt
    cryptsetup
    parted
    usbutils
    pciutils
    sdparm
    hdparm
    nvme-cli
  ];

  system.stateVersion = "25.05";
}
