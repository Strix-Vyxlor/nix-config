{ config, pkgs, userSettings, ... }:
{
  programs.home-manager.enable = true;

  imports = [
    ../../user/shell/sh.nix
    ../../user/app/git/git.nix
    ../../user/app/git/gh.nix    
  ];

  home.packages = with pkgs; [
    zsh
    git
  ];

  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    music = "${config.home.homeDirectory}/Media/Music";
    videos = "${config.home.homeDirectory}/Media/Videos";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    templates = "${config.home.homeDirectory}/Templates";
    download = "${config.home.homeDirectory}/Downloads";
    documents = "${config.home.homeDirectory}/Documents";
    desktop = null;
    publicShare = null;
  };

  xdg.mime.enable = true;
  xdg.mimeApps.enable = true;

  home.sessionVariables = {
    EDITOR = userSettings.editor;
  };
  
  news.display = "silent";

  home.stateVersion = "24.05";
}
