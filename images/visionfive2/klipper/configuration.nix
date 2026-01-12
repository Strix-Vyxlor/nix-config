{
  modulesPath,
  lib,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/image-based-appliance.nix")
    ./filesystems.nix
    ./image.nix
    ./inflate.nix
  ];

  boot.loader.grub.enable = false;
  boot.kernelParams = [
    "console=tty1"
    "console=serial1"
  ];
  boot.consoleLogLevel = lib.mkDefault 7;
  boot.initrd.kernelModules = [
    "clk-starfive-jh7110-aon"
    "clk-starfive-jh7110-stg"
    "phy-jh7110-pcie"
    "pcie-starfive"
    "nvme"
  ];

  networking.interfaces.end0.useDHCP = true;

  strixos = {
    hostName = "strix-printer";
    network = {
      manager = null;
      avahi = true;
    };
    locale = {
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
      consoleKeymap = "be-latin1";
    };
    hardware = {
      kernel = "testing";
    };
    services.ssh = {
      enable = true;
      rootPassword = true;
    };
  };

  nix.settings = {
    substituters = [
      "https://cache.ztier.in" # only nixos-unstable
    ];
    trusted-public-keys = [
      "cache.ztier.link-1:3P5j2ZB9dNgFFFVkCQWT3mh0E+S3rIWtZvoql64UaXM="
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.buildPlatform = "x86_64-linux";
  nixpkgs.hostPlatform = "riscv64-linux";

  users.users.test = {
    initialPassword = "test";
    isNormalUser = true;
  };
  users.users.root.initialPassword = "root";

  system.stateVersion = "25.11";
}
