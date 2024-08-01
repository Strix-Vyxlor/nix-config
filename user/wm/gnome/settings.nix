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
      command = "wofi";
      name = "launcher";
    };
  };
}
