{
  config,
  lib,
  pkgs,
  branch,
  stylix,
  ...
}: {
  strixos = {
    inherit branch;
    timezone = "Europe/Brussels";
  };

  # Simply install just the packages
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    helix # or some other editor, e.g. nano or neovim
  ];

  home-manager = {
    backupFileExtension = ".hbk";
    useGlobalPkgs = true;

    config = ./home.nix;
  };

  environment.motd = ''
    nix is crazy
  '';

  system.stateVersion = "24.05";
}
