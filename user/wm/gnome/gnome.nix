{ config, lib, pkgs, ... }:
{

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        blur-my-shell.extensionUuid
        caffeine.extensionUuid
        hide-keyboard-layout.extensionUuid
        quick-settings-tweaker.extensionUuid
        vitals.extensionUuid
      ];
    };
  };

  gtk.cursorTheme = {
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 24;
  };

  gtk.iconTheme = {
    package = pkgs.vimix-icon-theme;
    name = "Vimix-Black-dark";
  };

  home.packages = (with pkgs; [
    vimix-icon-theme
    vimix-cursors
    xdg-utils
    adwaita-icon-theme
  ]) ++ (with pkgs.gnomeExtensions; [
        blur-my-shell
        caffeine
        hide-keyboard-layout
        quick-settings-tweaker
        vitals
    ]);
}

