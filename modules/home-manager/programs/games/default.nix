{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.games;
in {
  options.strixos.programs.games = {
    minecraft = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable prismlauncher
      '';
    };
    heroic = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable heroic games launcher
      '';
    };
    mangohud = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable mangohud
      '';
    };
    goverlay = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable goverlay
      '';
    }; 
    dolphin = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable dolphin
      '';
    };
    retroarch = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable retroarch
        '';
      };
      withCores = mkOption {
        type = types.nullOr types.function;
        default = null;
        description = ''
          cores to include retroarch (else all installed)
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.minecraft {
      home.packages = [pkgs.prismlauncher];
    })
    (mkIf cfg.heroic {
      home.packages = [pkgs.heroic];
    })
    (mkIf cfg.mangohud {
      programs.mangohud.enable = true;
    })
    (mkIf cfg.goverlay {
      home.packages = [pkgs.goverlay];
    })
    (mkIf cfg.dolphin {
      home.packages = [pkgs.dolphin-emu];
    })
    (mkIf cfg.retroarch.enable {
      home.packages = if 
        cfg.retroarch.withCores == null 
        then 
        [pkgs.retroarch-full] 
        else 
        [pkgs.retroarch.withCores cfg.withCores];
    })
  ];
}
