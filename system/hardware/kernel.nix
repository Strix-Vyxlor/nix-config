{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_stable;
  boot.consoleLogLevel = 0;
}
