{ config, lib, pkgs, ... }:
{

  dconf = { 
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  programs.gnome-shell = {
    extensions = with pkgs.gnomeExtensions; [
      blur-my-shell
      caffeine
      hide-keyboard-layout
      quick-settings-tweaker
      vitals
    ];
  };

  gtk.cursorTheme = {
    package = pkgs.volantes-cursors;
    name = "volantes-cursors";
    size = 36;
  };

  home.packages = with pkgs; [
    papirus-icon-theme
    xdg-utils
    adwaita-icon-theme
  ];
}

