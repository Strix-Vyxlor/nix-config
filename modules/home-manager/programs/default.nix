inputs: {
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.strixos.programs;
in {
  imports = [
    ./cli
    ./editor
    (import ./browser inputs)
    ./graphics
    ./discord.nix
  ];
}
