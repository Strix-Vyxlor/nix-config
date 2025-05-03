{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.desktop.hyprland;
in {
  options.strixos.desktop.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable Hyprland window manager
      '';
    };
    xkb = mkOption {
      type = types.attrs;
      default = {
        layout = "us";
        variant = "";
        options = "";
      };
      description = ''
        attribute set to configure xkb
      '';
    };
    nautilus = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable support for mounting in nautilus/nemo and derivatives (gvfs)
      '';
    };
    keyring = mkOption {
      type = types.nullOr (types.enum [
        "gnome-keyring"
      ]);
      default = null;
      description = ''
        keyring manager to use (recomended)
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment = {
        variables.XDG_RUNTIME_DIR = "/run/user/$UID";
        plasma5.excludePackages = [pkgs.kdePackages.systemsettings];
        plasma6.excludePackages = [pkgs.kdePackages.systemsettings];
      };

      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
        systemd.setPath.enable = true;
      };

      services = {
        xserver.xkb = cfg.xkb; # NOTE: may need to enable xserver
        gvfs.enable = cfg.nautilus;
        udisks2.enable = cfg.nautilus;
      };
    }
    (mkIf (cfg.keyring == "gnome-keyring") {
      security.pam.services = {
        login.enableGnomeKeyring = true;
        sddm.enableGnomeKeyring = true;
        greetd.enableGnomeKeyring = true;
        gdm.enableGnomeKeyring = true;
        gdm-password.enableGnomeKeyring = true;
        ly.enableGnomeKeyring = true;
        gnome_keyring.enableGnomeKeyring = true;
      };

      services.gnome.gnome-keyring.enable = true;
    })
  ]);
}
