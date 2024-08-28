{ pkgs, userSettings, ... }:
{
  home.packages = with pkgs; [
    tmux
  ];

  programs.tmux = {
    enable = true;
    
    shell = "${userSettings.shell}";
  };
}
