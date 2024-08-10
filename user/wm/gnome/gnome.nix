{ config, lib, pkgs, ... }:
{
  imports = [
    ../../app/term/blackbox.nix
    ../../app/launcher/wofi.nix
    ./settings.nix
  ];

  stylix.targets.gnome.enable = true;
  stylix.targets.gedit.enable = true;
  dconf = {
    enable = true;
    # settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
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
    dconf-editor
    wl-clipboard
    adwaita-icon-theme
    gnome-tweaks
  ]) ++ (with pkgs.gnomeExtensions; [
        blur-my-shell
        caffeine
        hide-keyboard-layout
        quick-settings-tweaker
        vitals
    ]);
}

