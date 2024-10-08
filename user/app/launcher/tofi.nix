{
  pkgs,
  userSettings,
  config,
  ...
}: {
  programs.tofi = {
    enable = true;
    settings = {
      font = "${userSettings.font}";
      font-size = 16;

      terminal = "alacritty";

      corner-radius = 30;
      width = 500;
      height = 300;

      prompt-color = "#${config.lib.stylix.colors.base05}";
      prompt-background = "#${config.lib.stylix.colors.base00}";
      prompt-background-padding = "5, 7";
      prompt-background-corner-radius = 15;

      input-color = "#${config.lib.stylix.colors.base05}";
      input-background = "#${config.lib.stylix.colors.base00}";
      input-background-padding = "5, 0";

      selection-color = "#${config.lib.stylix.colors.base0E}";
      selection-background = "#${config.lib.stylix.colors.base02}";
      selection-background-padding = "2, 5";
      selection-background-corner-radius = 15;

      default-result-color = "#${config.lib.stylix.colors.base05}";
      default-result-background-corner-radius = 15;

      alternate-result-color = "#${config.lib.stylix.colors.base07}";
      alternate-result-background = "#${config.lib.stylix.colors.base01}";
      alternate-result-background-padding = "0, 5";
      alternate-result-background-corner-radius = 15;

      border-color = "#${config.lib.stylix.colors.base0D}";
      outline-width = 0;
      background-color = "#${config.lib.stylix.colors.base00}";
    };
  };
}
