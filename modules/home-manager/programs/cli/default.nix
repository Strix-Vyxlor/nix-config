{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./git.nix
    ./tmux.nix
  ];
}
