{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    blackbox-terminal
  ];

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

          "#${config.lib.stylix.colors.base00}", 
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
