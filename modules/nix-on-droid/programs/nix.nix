{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.nix;
in {
  options.strixos.programs.nix = {
    enableFlake = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable nix flake command
      '';
    };
    sandbox = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable nix sandbox
      '';
    };
  };

  config = mkMerge [
    {
      nix.settings = {inherit (cfg) sandbox;};
    }
    (mkIf cfg.enableFlake {
      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';
    })
  ];
}
