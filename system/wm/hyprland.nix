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
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    };
  };
  environment = {
    plasma5.excludePackages = [ pkgs.kdePackages.systemsettings ];
    plasma6.excludePackages = [ pkgs.kdePackages.systemsettings ];
  };
  services.xserver.excludePackages = [ pkgs.xterm ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "be";
      variant = "";
      options = "";
    };
  };
}
