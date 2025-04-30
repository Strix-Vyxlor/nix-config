{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption;
in {
  imports = [
    ./boot
    ./network
    ./style
    ./locale
    ./programs
    ./hardware
    ./services
    ./user
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
    hostName = mkOption {
      type = types.str;
      default = "nixos";
      description = ''
        hostname for the system
      '';
    };
  };

  config = {
    networking = {inherit (config.strixos) hostName;};
  };
}
