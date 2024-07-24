{ config, lib, pkgs, ... }:
{

  dconf = {
    settings."org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = with pkgs.gnomeExtensions; [
        blur-my-shell.extensionUuid
        gsconnect.extensionUuid
      ];
    };
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  gtk.cursorTheme = {
    package = pkgs.volantes-cursors;
    name = "volantes-cursors";
    size = 36;
  };

  home.packages = with pkgs; [
    papirus-icon-theme
    xdg-utils
    gnome.adwaita-icon-theme
  ];
}

