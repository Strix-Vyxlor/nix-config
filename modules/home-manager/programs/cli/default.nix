inputs: {
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.cli;
in {
  imports = [
    ./git.nix
    ./tmux.nix
    ./cava.nix
    inputs.zix.homeManagerModules.zix
  ];

  options.strixos.programs.cli = {
    yazi = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable yazi
        '';
      };
      makeDefault = mkOption {
        type = types.bool;
        default = false;
        description = ''
          make the default terminal file manager
        '';
      };
    };
  };

  config = {
    programs.yazi = {
      enable = cfg.yazi.enable;
    };

    lib.strixos.termFileManager =
      if cfg.yazi.makeDefault
      then "yazi"
      else null;
  };
}
