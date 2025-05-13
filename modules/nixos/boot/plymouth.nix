{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkIf mkMerge;
  cfg = config.strixos.boot.plymouth;
in {
  options.strixos.boot.plymouth = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable plymouth
      '';
    };
    style = mkOption {
      type = types.bool;
      default = false;
      description = ''
        style plymouth (requires stylix)
      '';
    };
    logo = mkOption {
      type = with lib.types; either path package;
      defaultText = lib.literalMD "NixOS logo";
      default = "${pkgs.nixos-icons}/share/icons/hicolor/256x256/apps/nix-snowflake.png";
      description = ''
        logo to be used on the boot screen
      '';
    };
    animate = mkOption {
      type = types.bool;
      default = true;
      description = ''
        disable when logo is not symmetrical
      '';
    };
  };

  config =
    mkIf cfg.enable
    {
      boot.plymouth.enable = true;
      stylix.targets.plymouth = {
        enable = true;
        inherit (cfg) logo;
        logoAnimated = cfg.animate;
      };
    };
}
