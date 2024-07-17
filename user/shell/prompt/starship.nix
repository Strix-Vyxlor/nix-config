{ pkgs, userSettings, ... }:
{
  programs.starship = {
    enable = true;
    enableBashIntegration = false;
    enableTransience = true;
  };

  home.packages = with pkgs; [
    starship
  ];
}
