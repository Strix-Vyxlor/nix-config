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
    trusted-users = mkOption {
      type = types.listOf types.str;
      default = ["root" "@wheel"];
      description = ''
        extra nix priveliges
      '';
    };
  };

  config = mkMerge [
    {
      nix.settings = {inherit (cfg) sandbox trusted-users;};
    }
    (mkIf cfg.enableFlake {
      nix.extraOptions = ''
        experimental-features = nix-command flakes
      '';
    })
  ];
}
