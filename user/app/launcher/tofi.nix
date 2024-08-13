{ pkgs, userSettings, config, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      font = "${userSettings.font}";
      font-size = 16;

      border-radius = 50;
      width = 600;
      height = 400;

      prompt-color = "#${config.lib.stylix.colors.base05}";
      prompt-background = "#${config.lib.stylix.colors.base01}";

      input-color = "#${config.lib.stylix.colors.base05}";
      input-background = "#${config.lib.stylix.colors.base01}";

      border-color = "#${config.lib.stylix.colors.base0D}";
      ouline-color = "#${config.lib.stylix.colors.base0C}";
      background-color = "#${config.lib.stylix.colors.base00}";

    };
  };
}
