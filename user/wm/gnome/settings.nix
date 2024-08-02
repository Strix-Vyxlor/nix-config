{ lib, ... }:
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      maximize = ["<Super>Page_Up"];
      minimize = ["<Super>Page_Down"];
    };

    # custom keymaps
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      command = "blackbox";
      name = "terminal";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "<Super>f";
      command = "nautilus";
      name = "files";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
      binding = "<Super>r";
      command = "wofi --allow-images";
      name = "launcher";
    };

    # settings
    "org/gnome/desktop/wm/preferences" = {
      focus-mode = "mouse";
    };

    # Mutter
    "org/gnome/mutter" = {
      center-new-windows = true;
      workspaces-only-on-primary = false;
    };

    # extension settings
    # blur my shell
    "org/gnome/shell/blur-my-shell/panel" = {
      static-blur = false;
      unblur-in-overview = true;
      sigma = mkIint32 20;
      brightness = mkDouble 0.9;
    };

    "org/gnome/shell/blur-my-shell/dash-to-dock" = {
      blur = true;
      static-blur = false;
      sigma = mkIint32 30;
      brightness = mkDouble 0.6;
      override-background = true;
    };

    "org/gnome/shell/blur-my-shell/applications" = {
      blur = true;
      enable-all = true;
      dynamic-opacity = false;
      blur-on-overview = false;
      sigma = mkIint32 10;
      opacity = mkIint32 200;
      brightness = mkDouble 1.0;
      blacklist = [ 
        "Plank"
        "com.desktop.ding"
        "Conky" 
        "Brave-browser" 
        "org.gnome.Boxes"
      ];
    };

    # vitals
    "org/gnome/shell/extensions/vitals" = {
      fixed-widths = true;
      menu-centered = true;
      position-in-panel = mkIint32 0;

      show-battery = false;
      show-storage = false;
      show-system = true;
      show-voltage = false;
    };

    # quick settings
    "org/gnome/shell/extensions/quick-settings-tweaks" = {
      add-dnd-quick-toggle-enable = false;
      notifications-enabled = false;
      user-removed-buttons = [
        "PowerProfilesToggle" 
        "KeyboardBrightnessToggle" 
        "NightLightToggle"
      ];
    };
  };
}
