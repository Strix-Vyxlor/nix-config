{ lib, ... }:
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
    };
  };
}
