{
  pkgs,
  config,
  branch,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

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
      graphics = true;
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

  services.k3s = {
    enable = true;
    extraFlags = [
      "--service-node-port-range 2000-32767"
    ];
  };

  hardware.nvidia = {
    open = false;
    nvidiaSettings = false;
    package = config.boot.kernelPackages.nvidiaPackages.legacy_390;
  };

  hardware.nvidia-container-toolkit = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "Strix Share";
        "netbios name" = "STRIX-SERVER";
        "security" = "user";
        "map to guest" = "Bad User";
        "guest account" = "nobody";
      };
      "Public" = {
        "path" = "/hdd/public";
        "browsable" = "yes";
        "writable" = "yes";
        "guest ok" = "yes";
        "create mask" = "0775";
        "directory mask" = "0775";
      };
      "Private" = {
        "path" = "/hdd/private";
        "browsable" = "yes";
        "writable" = "yes";
        "guest ok" = "no";
        "valid users" = "strix";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  programs.mosh.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  environment.systemPackages = with pkgs; [
    kubernetes-helm
    kitty.terminfo
    helix
    wget
    git
    home-manager
  ];

  environment.variables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  system.stateVersion = "25.05";
}
