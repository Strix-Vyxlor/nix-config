{ inputs, pkgs, lib, ... }:
{
  # Import wayland config
  imports = [
              ./pipewire.nix
              ./dbus.nix
            ];

  # Security
  security = {
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  programs = {
    hyprland = {
      enable = true;
      xwayland = {
        enable = true;
      };
      systemd.setPath.enable = true;
    };
  };
  environment = {
    plasma5.excludePackages = [ pkgs.kdePackages.systemsettings ];
    plasma6.excludePackages = [ pkgs.kdePackages.systemsettings ];
  };
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "be";
      variant = "";
      options = "";
    };
    displayManager.lightdm = {
      enable = true;
      greeters.gtk.enable = true;
      greeters.gtk.clock-format = "%H:%M";
    };
  };

  stylix.targets.lightdm.enable = true;
}