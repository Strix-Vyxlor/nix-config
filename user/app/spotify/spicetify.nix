{ config, lib, pkgs, inputs, systemSettings, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${systemSettings.system};
in {
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  programs.spicetify =
    {
      enable = true;

      theme = spicePkgs.themes.sleek;
      colorScheme = "custom";

      customColorScheme = {
        text = "${config.lib.stylix.colors.base04}";
        subtext = "${config.lib.stylix.colors.base03}";
        sidebar-text = "${config.lib.stylix.colors.base07}";
        main = "${config.lib.stylix.colors.base00}";
        sidebar = "${config.lib.stylix.colors.base02}";
        player = "${config.lib.stylix.colors.base0D}";
        card = "${config.lib.stylix.colors.base02}";
        shadow = "${config.lib.stylix.colors.base01}";
        selected-row = "${config.lib.stylix.colors.base02}";
        button = "${config.lib.stylix.colors.base09}";
        button-active = "${config.lib.stylix.colors.base0D}";
        button-disabled = "${config.lib.stylix.colors.base03}";
        tab-active = "${config.lib.stylix.colors.base0D}";
        notification = "${config.lib.stylix.colors.base0B}";
        notification-error = "${config.lib.stylix.colors.base08}";
        misc = "${config.lib.stylix.colors.base0A}";
      };

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        lyricsPlus
      ];

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
      ];
    };
}
