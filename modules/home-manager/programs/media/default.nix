inputs: {
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.strixos.programs.media;
in {
  imports = [
    ./discord.nix
    (import ./spicetify.nix inputs)
  ];
}
