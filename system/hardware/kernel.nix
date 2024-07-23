{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.consoleLogLevel = 0;
}
