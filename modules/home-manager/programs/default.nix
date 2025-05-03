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
    (import ./browser inputs)
    ./graphics
  ];
}
