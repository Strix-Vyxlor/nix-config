{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
  cfg = config.strixos.desktop;
in {
  imports = [./hyprland];
}
