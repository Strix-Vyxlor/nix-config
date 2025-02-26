{
  config,
  pkgs,
  lib,
  style ? false,
  ...
}: {
  home.packages = [
    (pkgs.discord.override {
      withVencord = true;
    })
  ];

  imports =
    if style
    then [./theme.nix]
    else [];
}
