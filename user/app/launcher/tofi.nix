{ pkgs, userSettings, config, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      font = "${userSettings.font}";

      prompt-color = "#${config.lib.stylix.colors.base05}";
      prompt-background = "#${config.lib.stylix.colors.base02}";

      input-color = "#${config.lib.stylix.colors.base05}";
      input-background = "#${config.lib.stylix.colors.base02}";
    };
  };
}
