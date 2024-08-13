{ pkgs, config, lib, userSettings, ... }:
{
  imports = [
    ../../app/term/alacritty.nix
    ../../app/launcher/tofi.nix
    ./waybar.nix
    ./hypr.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    settings = { };
    extraConfig = ''
      exec-once = dbus-update-activation-environment DISPLAY XAUTHORITY WAYLAND_DISPLAY
      exec-once = hyprctl setcursor '' + config.gtk.cursorTheme.name + " " + builtins.toString config.gtk.cursorTheme.size + ''

      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = WLR_DRM_DEVICES,/dev/dri/card2:/dev/dri/card1
      env = GDK_BACKEND,wayland,x11,*
      env = QT_QPA_PLATFORM,wayland;xcb
      env = QT_QPA_PLATFORMTHEME,qt5ct
      env = QT_AUTO_SCREEN_SCALE_FACTOR,1
      env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
      env = CLUTTER_BACKEND,wayland
      env = GDK_PIXBUF_MODULE_FILE,${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache

      exec-once = nm-applet
      exec-once = blueman-applet

      exec-once = hyprpaper
      exec-once = hypridle
      exec-once = waybar

      bezier = wind, 0.05, 0.9, 0.1, 1.05
      bezier = winIn, 0.1, 1.1, 0.1, 1.0
      bezier = winOut, 0.3, -0.3, 0, 1
      bezier = liner, 1, 1, 1, 1
      bezier = linear, 0.0, 0.0, 1.0, 1.0

      animations {
           enabled = yes
           animation = windowsIn, 1, 6, winIn, popin
           animation = windowsOut, 1, 5, winOut, popin
           animation = windowsMove, 1, 5, wind, slide
           animation = border, 1, 10, default
           animation = borderangle, 1, 100, linear, loop
           animation = fade, 1, 10, default
           animation = workspaces, 1, 5, wind
           animation = windows, 1, 6, wind, slide
      }

      general {
        layout = dwindle
        border_size = 5
        col.active_border = 0xff'' + config.lib.stylix.colors.base08 + " " + ''0xff'' + config.lib.stylix.colors.base09 + " " + ''0xff'' + config.lib.stylix.colors.base0A + " " + ''0xff'' + config.lib.stylix.colors.base0B + " " + ''0xff'' + config.lib.stylix.colors.base0C + " " + ''0xff'' + config.lib.stylix.colors.base0D + " " + ''0xff'' + config.lib.stylix.colors.base0E + " " + ''0xff'' + config.lib.stylix.colors.base0F + " " + ''270deg

        col.inactive_border = 0xaa'' + config.lib.stylix.colors.base02 + ''

        resize_on_border = true
        gaps_in = 5
        gaps_out = 5
      }

      cursor {
        no_warps = false
        inactive_timeout = 30
      }

      bind = SUPER, R, exec, tofi
      bind = SUPER, Q, killactive
      bind = SUPER, F, exec, nautilus
      bind = SUPER, B, exec, ${userSettings.browser}
      bind = SUPER, T, exec, alacritty

      bind = SUPER, H, movefocus, l
      bind = SUPER, J, movefocus, d
      bind = SUPER, K, movefocus, u
      bind = SUPER, L, movefocus, r

      bind = SUPERSHIFT, H, movewindow, l
      bind = SUPERSHIFT, J, movewindow, d
      bind = SUPERSHIFT, K, movewindow, u
      bind = SUPERSHIFT, L, movewindow, r

      bindm = SUPER, mouse:272, movewindow
      bindm = SUPER, mouse:273, resizewindow

      bind = ,XF86AudioMute, exec, swayosd-client --output-volume mute-toggle
      bind = ,XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle
      bind = ,XF86AudioLowerVolume, exec, swayosd-client --output-volume lower
      bind = ,XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise

      bind = ,XF86MonBrightnessUp, exec, swayosd-client --brightness raise 
      bind = ,XF86MonBrightnessDown, exec, swayosd-client --brightness lower

      $pavucontrol = class:^(org.pulseaudio.pavucontrol)$
      windowrulev2 = float,$pavucontrol
      windowrulev2 = size 86% 40%,$pavucontrol
      windowrulev2 = move 50% 6%,$pavucontrol
      windowrulev2 = workspace special silent,$pavucontrol
      windowrulev2 = opacity 0.80,$pavucontrol

      windowrulev2 = opacity 0.85,class:^(org.gnome.Nautilus)$

      layerrule = blur,alacritty
      blurls = alacritty

      layerrule = blur,waybar
      layerrule = xray,waybar
      blurls = waybar

      layerrule = blur,gtk-layer-shell
      layerrule = xray,gtk-layer-shell
      blurls = gtk-layer-shell

      monitor = eDP-1, 1920x1200, 0x0x, 1
      monitor = HDMI-A-1, 1920x1080, -1920x0, 1

      input {
        kb_layout = be
        repeat_delay = 350
        repeat_rate = 50
        accel_profile = adaptive
        follow_mouse = 2
        numlock_by_default = true

        touchpad {
          natural_scroll = yes
          disable_while_typing = false
        }
      }

      decoration {
        rounding = 8
        blur {
          enabled = true
          size = 5
          passes = 2
          ignore_opacity = true
          contrast = 1.17
          brightness = '' + (if (config.stylix.polarity == "dark") then "0.8" else "1.25") + ''
          xray = true
        }
      }

    '';
    xwayland = { enable = true; };
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    killall
    nautilus
    libva-utils
    libinput-gestures
    gsettings-desktop-schemas
    libsForQt5.qt5.qtwayland
    qt6.qtwayland 

    wlr-randr
    wl-clipboard
    hyprland-protocols
    hyprpicker
    hypridle
    hyprpaper
    hyprlock
    fnott

    networkmanagerapplet
    blueman

    pavucontrol
    pamixer
    xdg-utils
  ];

  services.swayosd.enable = true;
  services.swayosd.topMargin = 0.5;

  services.fnott.enable = true;
  services.fnott.settings = {
    main = {
      anchor = "top-right";
      stacking-order = "top-down";
      min-width = 400;
      title-font = userSettings.font + ":size=14";
      summary-font = userSettings.font + ":size=12";
      body-font = userSettings.font + ":size=11";
      border-size = 0;
    };
    low = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base03 + "ff";
      summary-color = config.lib.stylix.colors.base03 + "ff";
      body-color = config.lib.stylix.colors.base03 + "ff";
      idle-timeout = 150;
      max-timeout = 30;
      default-timeout = 8;
    };
    normal = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base07 + "ff";
      summary-color = config.lib.stylix.colors.base07 + "ff";
      body-color = config.lib.stylix.colors.base07 + "ff";
      idle-timeout = 150;
      max-timeout = 30;
      default-timeout = 8;
    };
    critical = {
      background = config.lib.stylix.colors.base00 + "e6";
      title-color = config.lib.stylix.colors.base08 + "ff";
      summary-color = config.lib.stylix.colors.base08 + "ff";
      body-color = config.lib.stylix.colors.base08 + "ff";
      idle-timeout = 0;
      max-timeout = 0;
      default-timeout = 0;
    };
  };


  services.hyprpaper.enable = true;
  stylix.targets.hyprpaper.enable = true;
}
