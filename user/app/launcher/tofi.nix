{ pkgs, userSettings, config, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      font = "${userSettings.font}";
      text-color = "#${config.lib.stylix.colors.base05}";
    };
  };
}
