inputs: {
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./git.nix
    ./tmux.nix
    ./cava.nix
    inputs.zix.homeManagerModules.zix
  ];
}
