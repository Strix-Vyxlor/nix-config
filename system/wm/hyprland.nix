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
    greetd.enableGnomeKeyring = true;
    gdm.enableGnomeKeyring = true;
    gdm-password.enableGnomeKeyring = true;
    ly.enableGnomeKeyring = true;
  };

  environment.variables.XDG_RUNTIME_DIR = "/run/user/$UID";

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

  services.displayManager.ly = {
    enable = true;
    settings = {
      clock = "%I:%M:%S %p\n%A %d %B";
      clear_password = true;
      cmatrix_fg = "0x05";
      animation = "matrix"; 
    };
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
