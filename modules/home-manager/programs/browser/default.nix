inputs: {
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./brave.nix
    (import ./zen.nix inputs)
  ];
}
