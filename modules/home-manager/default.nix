inputs: {
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types;
in {
  imports = [
    ./user
    ./shell
    ./xdg
    ./style
    (import ./programs inputs)
  ];

  options.strixos = {
    branch = mkOption {
      type = types.enum [
        "stable"
        "unstable"
      ];
      default = "stable";
      description = ''
        branch of nixpkgs
      '';
    };
  };

  config = {
    programs.home-manager.enable = true; # important
    news.display = "silent"; # I dont need this
  };
}
