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
      vitalsquick settings
    ];
  };

  gtk.cursorTheme = {
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 36;
  };

  gtk.iconTheme = {
    package = pkgs.vimix-icon-theme;
    name = "Vimix-black-dark";
  };

  home.packages = with pkgs; [
    vimix-icon-theme
    vimix-cursors
    xdg-utils
    adwaita-icon-theme
  ];
}

