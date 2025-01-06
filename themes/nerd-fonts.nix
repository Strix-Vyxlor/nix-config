{
  pkgs,
  lib,
  ...
}: {
  home.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
}
