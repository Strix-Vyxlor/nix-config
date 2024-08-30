{ ... }:

{

  networking.firewall.enable = true;

  networking.firewall.allowedTCPPorts = [ ]; # syncthing
  networking.firewall.allowedUDPPorts = [ ]; # syncthing
}
