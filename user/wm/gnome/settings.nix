{ lib, ... }:
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
      maximize = ["<Super>Page_Up"];
      minimize = ["<Super>Page_Down"];

      switch-to-workspace-left = [];
      switch-to-workspace-right = [];

      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];
      switch-to-workspace-5 = ["<Super>5"];
      switch-to-workspace-6 = ["<Super>6"];
      switch-to-workspace-7 = ["<Super>7"];
      switch-to-workspace-8 = ["<Super>8"];
      switch-to-workspace-9 = ["<Super>9"];
      switch-to-workspace-10 = ["<Super>0"];

      move-to-workspace-1 = ["<Shift><Super>1"];
      move-to-workspace-2 = ["<Shift><Super>2"];
      move-to-workspace-3 = ["<Shift><Super>3"];
      move-to-workspace-4 = ["<Shift><Super>4"];
      move-to-workspace-5 = ["<Shift><Super>5"];
      move-to-workspace-6 = ["<Shift><Super>6"];
      move-to-workspace-7 = ["<Shift><Super>7"];
      move-to-workspace-8 = ["<Shift><Super>8"];
      move-to-workspace-9 = ["<Shift><Super>9"];
      move-to-workspace-10 = ["<Shift><Super>0"];
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
      unblur-in-overview = false;
      sigma = mkInt32 20;
      brightness = mkDouble 0.9;
    };

    "org/gnome/shell/blur-my-shell/dash-to-dock" = {
      blur = true;
      static-blur = false;
      sigma = mkInt32 30;
      brightness = mkDouble 0.6;
      override-background = true;
    };

    "org/gnome/shell/blur-my-shell/applications" = {
      blur = true;
      enable-all = true;
      dynamic-opacity = false;
      blur-on-overview = false;
      sigma = mkInt32 10;
      opacity = mkInt32 200;
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
      position-in-panel = mkInt32 0;

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
