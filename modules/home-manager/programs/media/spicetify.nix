inputs: {
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.media.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};

  extensionType = lib.types.either lib.types.pathInStore (
    lib.types.submodule {
      freeformType = lib.types.attrsOf lib.types.anything;
      options = {
        src = lib.mkOption {
          type = lib.types.pathInStore;
          description = "Path to the folder which contains the .js file.";
        };
        name = lib.mkOption {
          type = lib.types.str;
          description = "Name of the .js file to enable.";
          example = "dribbblish.js";
        };
        experimentalFeatures = lib.mkEnableOption "experimental_features in config-xpui.ini";
      };
    }
  );

  customAppType = lib.types.submodule {
    freeformType = lib.types.attrsOf lib.types.anything;
    options = {
      src = lib.mkOption {
        type = lib.types.pathInStore;
        description = "Path to the folder containing the app code.";
        example = lib.literalExpression ''
          pkgs.fetchFromGitHub {
            owner = "hroland";
            repo = "spicetify-show-local-files";
            rev = "1bfd2fc80385b21ed6dd207b00a371065e53042e";
            hash = "sha256-neKR2WaZ1K10dZZ0nAKJJEHNS56o8vCpYpi+ZJYJ/gU=";
          }
        '';
      };
      name = lib.mkOption {
        type = lib.types.str;
        description = "Name of the app. No spaces or special characters";
        example = "localFiles";
        default = "";
      };
    };
  };
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  options.strixos.programs.media.spicetify = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable spicetify (spotify)
      '';
    };
    customApps = mkOption {
      type = let
        fromType = types.listOf customAppType;
      in
        types.functionTo fromType;
      default = _: [];
      description = ''
        custom apps to add to spicetify
        uses form of a: [a.customApp]
      '';
    };
    extensions = mkOption {
      type = let
        fromType = types.listOf extensionType;
      in
        types.functionTo fromType;
      default = _: [];
      description = ''
        extensions to add to spicetify
        uses form of a: [a.extension]
      '';
    };
    style = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable custom theme for spicetify
        '';
      };
      theme = mkOption {
        type = types.enum [
          "default"
          "blossom"
          "burntSienna"
          "dreary"
          "dribbblish"
          "flow"
          "matte"
          "nightlight"
          "onepunch"
          "sleek"
          "starryNight"
          "turntable"
          "ziro"
          "text"
          "cattpuccin"
          "comfy"
          "dracula"
          "nord"
          "fluent"
          "defaultDynamic"
          "retroBlur"
          "omni"
          "bloom"
          "lucid"
          "orchis"
          "hazy"
        ];
        default = "default";
        description = ''
          the theme to use
        '';
      };
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      programs.spicetify = {
        enable = true;
        theme = spicePkgs.themes.${cfg.style.theme};
        enabledCustomApps = cfg.customApps spicePkgs.apps;
        enabledExtensions = cfg.extensions spicePkgs.extensions;
      };
    }
    (mkIf cfg.style.enable {
      programs.spicetify = {
        colorScheme = "custom";
        customColorScheme = {
          text = "${config.lib.stylix.colors.base05}";
          subtext = "${config.lib.stylix.colors.base05}";
          sidebar-text = "${config.lib.stylix.colors.base07}";
          main = "${config.lib.stylix.colors.base00}";
          sidebar = "${config.lib.stylix.colors.base00}";
          player = "${config.lib.stylix.colors.base0D}";
          card = "${config.lib.stylix.colors.base02}";
          shadow = "${config.lib.stylix.colors.base01}";
          selected-row = "${config.lib.stylix.colors.base02}";
          button = "${config.lib.stylix.colors.base0D}";
          button-active = "${config.lib.stylix.colors.base0D}";
          button-disabled = "${config.lib.stylix.colors.base02}";
          tab-active = "${config.lib.stylix.colors.base0D}";
          notification = "${config.lib.stylix.colors.base0B}";
          notification-error = "${config.lib.stylix.colors.base08}";
          misc = "${config.lib.stylix.colors.base02}";
        };
      };
    })
  ]);
}
