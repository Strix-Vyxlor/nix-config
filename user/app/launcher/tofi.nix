{ pkgs, userSettings, config, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      font = "${userSettings.font}";
      font-size = 16;

      border-radius = 100;
      width = 500;
      height = 300;

      prompt-color = "#${config.lib.stylix.colors.base05}";
      prompt-background = "#${config.lib.stylix.colors.base01}";

      input-color = "#${config.lib.stylix.colors.base05}";
      input-background = "#${config.lib.stylix.colors.base01}";

      selection-color = "#${config.lib.stylix.colors.base0E}";
      selection-background = "#${config.lib.stylix.colors.base02}"; 
      selection-background-padding = "5, 2";

      border-color = "#${config.lib.stylix.colors.base0D}";
      ouline-color = "#${config.lib.stylix.colors.base0C}";
      background-color = "#${config.lib.stylix.colors.base00}";

    };
  };
}
