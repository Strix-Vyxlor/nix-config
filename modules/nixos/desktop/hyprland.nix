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
    hyprlock = mkOption {
      type = types.bool;
      default = true;
      description = ''
        hyprlock pam configuration
      '';
    };
    pipewire = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable pipewire and wireblumper and all submodules
      '';
    };
    dbus = mkOption {
      type = types.bool;
      default = true;
      description = ''
        why would you disable this
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

        pipewire = {
          enable = cfg.pipewire;
          alsa.enable = true;
          pulse.enable = true;
          jack.enable = true;
          alsa.support32Bit = pkgs.system == "x86_64-linux";
        };
        dbus = {
          enable = cfg.dbus;
          packages = [pkgs.dconf];
        };
      };

      security.rtkit.enable = cfg.pipewire;
      programs.dconf.enable = cfg.dbus;
    }
    (mkIf (cfg.keyring == "gnome-keyring") {
      security.pam.services = {
        login.enableGnomeKeyring = true;
        sddm.enableGnomeKeyring = true;
        greetd.enableGnomeKeyring = true;
        gdm.enableGnomeKeyring = true;
        gdm-password.enableGnomeKeyring = true;
        ly.enableGnomeKeyring = true;
      };

      services.gnome.gnome-keyring.enable = true;
    })
    (mkIf cfg.hyprlock {
      security.pam.services.hyprlock = {};
    })
  ]);
}
