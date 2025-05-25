{
  pkgs,
  lib,
  branch,
  ...
}: let
  usb-gadget = pkgs.writeScriptBin "usb-gadget" builtins.readFile ./usb-gadget;
in {
  imports = [
    ./system/hardware-configuration.nix
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
      rpiConfig = ''
        dtoverlay=dwc2
      '';
      rpiParamsPost = ["modules-load=dwc2"];
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
      consoleKeymap = "be-latin1";
    };
    programs = {
      superuser = "doas";
      git = true;
    };
    services = {
      timesync = "chrony";
      ssh.enable = true;
    };
    style.theme.generateWithImage = ../../../themes/background/starry-night.jpg;
  };

  boot.kernelModules = [
    "libcomposite"
  ];

  systemd.services.usbgadget = {
    description = "My USB gadget";
    after = ["network-online.target"];
    wants = ["network-online.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      ExecStart = "${usb-gadget}/bin/usb-gadget";
    };
    wantedBy = ["sysinit.target"];
  };

  network.bridges.br0.interfaces = [
    "usb0"
    "usb1"
  ];

  networking.interfaces.br0 = {
    useDHCP = false;
    ipv4.addresses = [
      {
        address = "10.55.0.1";
        prefixLength = 24;
      }
    ];
  };

  zramSwap.enable = true;

  services.dnsmasq = {
    enable = true;
    settings = {
      dhcp-authoritative = null;
      dhcp-rapid-commit = null;
      no-ping = null;
      interface = "br0";
      dhcp-range = ["10.55.0.2,10.55.0.6,255.255,255.248,1h"];
      dhcp-option = ["3"];
      leasefile-ro = null;
    };
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
