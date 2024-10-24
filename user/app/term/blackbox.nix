{
  config,
  pkgs,
  lib,
  userSettings,
  ...
}: {
  home.packages = with pkgs; [
    blackbox-terminal
  ];

  dconf.settings = with lib.hm.gvariant; {
    "com/raggesilver/BlackBox" = {
      command-as-login-shell = false;
      use-custom-command = true;
      custom-shell-command = "/home/strix/.nix-profile/bin/${userSettings.shell}";
      font = "ZedMono Nerd Font 14";
      theme-dark = "Stylix";
      scrollback-mode = mkInt32 1;
      style-preference = mkInt32 2;
      working-directory-mode = mkInt32 1;
      terminal-bell = false;
      show-headerbar = false;
      floating-controls = true;
    };
  };

  home.file.".local/share/blackbox/schemes/stylix.json" = {
    text = ''
      {
        "name": "Stylix",
        "comment": "System style for blackbox",
        "use-theme-colors": false,
        "foreground-color": "#${config.lib.stylix.colors.base05}",
        "background-color": "#${config.lib.stylix.colors.base00}",
        "palette": [
          "#${config.lib.stylix.colors.base00}",
          "#${config.lib.stylix.colors.base08}",
          "#${config.lib.stylix.colors.base0B}",
          "#${config.lib.stylix.colors.base0A}",
          "#${config.lib.stylix.colors.base09}",
          "#${config.lib.stylix.colors.base0E}",
          "#${config.lib.stylix.colors.base0C}",
          "#${config.lib.stylix.colors.base07}",

          "#${config.lib.stylix.colors.base03}",
          "#${config.lib.stylix.colors.base08}",
          "#${config.lib.stylix.colors.base0B}",
          "#${config.lib.stylix.colors.base0A}",
          "#${config.lib.stylix.colors.base09}",
          "#${config.lib.stylix.colors.base0E}",
          "#${config.lib.stylix.colors.base0C}",
          "#${config.lib.stylix.colors.base07}"
        ]
      }
    '';
  };
}
