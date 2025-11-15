{modulesPath, ...}: {
  imports = [
    (modulesPath + "/profiles/image-based-appliance.nix")
    ./filesystems.nix
    ./image.nix
    ./inflate.nix
  ];

  boot.loader.grub.enable = false;
  boot.kernelParams = ["console=tty1" "console=serial1"];

  strixos = {
    hostName = "octoFive";
    network = {
      manager = "network-manager";
      avahi = true;
    };
    locale = {
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
      consoleKeymap = "be-latin1";
    };
    hardware = {
      kernel = "lts";
    };
    services.ssh = {
      enable = true;
      rootPassword = true;
    };
  };

  nixpkgs.crossSystem = {
    config = "riscv64-unknown-linux-gnu";
    system = "riscv64-linux";
  };
  users.users.root.initialPassword = "root";
}
