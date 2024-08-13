{ inputs, pkgs, lib, ... }:
{
  # Import wayland config
  imports = [
              ./pipewire.nix
              ./dbus.nix
            ];

  # Security
  security.pam.services = {
    login.enableGnomeKeyring = true;
    sddm.enableGnomeKeyring = true;
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

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  stylix.targets.gnome.enable = true;

  services.xserver = {
    enable = true;
    xkb = {
      layout = "be";
      variant = "";
      options = "";
    };
  };
}
