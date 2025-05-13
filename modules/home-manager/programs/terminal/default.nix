{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.terminal;
in {
  imports = [
    ./kitty.nix
  ];
}
