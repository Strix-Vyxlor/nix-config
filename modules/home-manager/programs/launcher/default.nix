{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.strixos.programs.launcher;
in {
  imports = [
    ./tofi.nix
  ];
}
