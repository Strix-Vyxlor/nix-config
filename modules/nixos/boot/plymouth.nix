{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) types mkOption mkIf mkMerge;
  cfg = config.strixos.boot.plymouth;
  # nixos-icons = pkgs.nixos-icons.overrideAttrs (oldAttrs: {
  #   src = pkgs.applyPatches {
  #     inherit (oldAttrs) src;
  #     prePatch = with config.lib.stylix.colors; ''
  #       # substituteInPlace logo/nix-snowflake-colours.svg --replace-fail '#415e9a' '#${base0D}'
  #       # substituteInPlace logo/nix-snowflake-colours.svg --replace-fail '#4a6baf' '#${base0D}'
  #       # substituteInPlace logo/nix-snowflake-colours.svg --replace-fail '#5277c3' '#${base0D}'
  #       #
  #       # substituteInPlace logo/nix-snowflake-colours.svg --replace-fail '#699ad7' '#${base0C}'
  #       # substituteInPlace logo/nix-snowflake-colours.svg --replace-fail '#7eb1dd' '#${base0C}'
  #       # substituteInPlace logo/nix-snowflake-colours.svg --replace-fail '#7ebae4' '#${base0C}'
  #
  #       substituteInPlace logo/nix-snowflake-colours.svg --replace-fail '#ff9999' '#${base0D}'
  #       substituteInPlace logo/nix-snowflake-colours.svg --replace-fail '#9999ff' '#${base0C}'
  #
  #
  #       # Insert attribution comment after the XML prolog
  #       sed \
  #         --in-place \
  #         '2i<!-- The original NixOS logo from ${oldAttrs.src.url} is licensed under https://creativecommons.org/licenses/by/4.0 and has been modified to match the ${scheme} color scheme. -->' \
  #         logo/nix-snowflake-colours.svg
  #     '';
  #   };
  # });
in {
  options.strixos.boot.plymouth = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable plymouth
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
