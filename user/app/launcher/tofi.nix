{ pkgs, userSettings, config, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      font = "${userSettings.font}";
    };
  };
}
