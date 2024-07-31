{ config, lib, pkgs, stylix, ... }:
{

  stylix.targets.gnome.enable = true;
  stylix.targets.gedit.enable = true;
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

  home.packages = (with pkgs; [ 
    xdg-utils
    blackbox-terminal
    dconf-editor
    adwaita-icon-theme
  ]) ++ (with pkgs.gnomeExtensions; [
        blur-my-shell
        caffeine
        hide-keyboard-layout
        quick-settings-tweaker
        vitals
    ]);
}

