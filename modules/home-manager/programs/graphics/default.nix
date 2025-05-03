{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.graphics;
in {
  options.strixos.programs.graphics = {
    aseprite = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable aseprite
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.aseprite {
      home.packages = [pkgs.aseprite];
    })
  ];
}
