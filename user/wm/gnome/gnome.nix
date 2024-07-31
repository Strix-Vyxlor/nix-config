{ config, lib, pkgs, inputs, ... }:
{
  
  imports = [ inputs.stylix.homeManagerModules.stylix ];

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

  stylix.targets.gnome.enable = true;

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

