{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.desktop;
in {
  imports = [
    ./hyprland.nix
    ./display-manager.nix
  ];
}
