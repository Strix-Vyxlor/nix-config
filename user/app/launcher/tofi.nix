{ pkgs, userSettings, config, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      font = "${userSettings.font}";
      border-radius = 10;
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
