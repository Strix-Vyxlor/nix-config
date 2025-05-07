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
    (import ./cli inputs)
    (import ./editor inputs)
    (import ./browser inputs)
    ./graphics
    ./games
    (import ./media inputs)
  ];
}
