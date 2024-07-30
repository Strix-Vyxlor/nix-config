{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_6_9;
  boot.consoleLogLevel = 0;
}
