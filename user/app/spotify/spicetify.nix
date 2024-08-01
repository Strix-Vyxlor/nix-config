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
        text = "${config.lib.stylix.colors.base0E}";
        subtext = "${config.lib.stylix.colors.base05}";
        sidebar-text = "${config.lib.stylix.colors.base07}";
        main = "${config.lib.stylix.colors.base00}";
        sidebar = "${config.lib.stylix.colors.base02}";
        player = "${config.lib.stylix.colors.base02}";
        card = "${config.lib.stylix.colors.base02}";
        shadow = "${config.lib.stylix.colors.base01}";
        selected-row = "${config.lib.stylix.colors.base04}";
        button = "${config.lib.stylix.colors.base09}";
        button-active = "${config.lib.stylix.colors.base0C}";
        button-disabled = "${config.lib.stylix.colors.base03}";
        tab-active = "${config.lib.stylix.colors.base0E}";
        notification = "${config.lib.stylix.colors.base0B}";
        notification-error = "${config.lib.stylix.colors.base08}";
        misc = "${config.lib.stylix.colors.base0A}";
      };

      enabledCustomApps = with spicePkgs.apps; [
        new-releases
        lyrics-plus
      ];

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        hidePodcasts
      ];
    };
}
