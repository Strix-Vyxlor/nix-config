{ pkgs, config, inputs, userSettings, ... }:
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
    plugins = with pkgs.hyprlandPlugins; [
      hyprgrass
      hyprexpo
    ];
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

      bind = SUPER, R, exec, tofi-drun | xargs hyprctl dispatch exec --
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

      bind = ,XF86AudioNext, exec, playerctl next
      bind = ,XF86AudioPrev, exec, playerctl previous
      bind = ,XF86AudioPlay, exec, playerctl play-pause
      bind = ,XF86AudioPause, exec, playerctl play-pause

      bind = ,Cancel, exec, playerctl next
      bind = ,XF86Messenger, exec, playerctl previous
      bind = ,XF86Go, exec, playerctl play-pause
      bind = ,XF86Favorites, exec, spotify

      bind = SUPER, ampersand, focusworkspaceoncurrentmonitor, 1
      bind = SUPER, eacute, focusworkspaceoncurrentmonitor, 2
      bind = SUPER, quotedbl, focusworkspaceoncurrentmonitor, 3
      bind = SUPER, apostrophe, focusworkspaceoncurrentmonitor, 4
      bind = SUPER, parenleft, focusworkspaceoncurrentmonitor, 5
      bind = SUPER, section, focusworkspaceoncurrentmonitor, 6
      bind = SUPER, egrave, focusworkspaceoncurrentmonitor, 7
      bind = SUPER, exclam, focusworkspaceoncurrentmonitor, 8
      bind = SUPER, ccedilla, focusworkspaceoncurrentmonitor, 9

      bind = SUPERSHIFT, ampersand, movetoworkspace, 1
      bind = SUPERSHIFT, eacute, movetoworkspace, 2
      bind = SUPERSHIFT, quotedbl, movetoworkspace, 3
      bind = SUPERSHIFT, apostrophe, movetoworkspace, 4
      bind = SUPERSHIFT, parenleft, movetoworkspace, 5
      bind = SUPERSHIFT, section, movetoworkspace, 6
      bind = SUPERSHIFT, egrave, movetoworkspace, 7
      bind = SUPERSHIFT, exclam, movetoworkspace, 8
      bind = SUPERSHIFT, ccedilla, movetoworkspace, 9

      bind=SUPER,Z,exec,if hyprctl clients | grep scratch_term; then echo "scratch_term respawn not needed"; else alacritty --class scratch_term; fi
      bind=SUPER,Z,togglespecialworkspace,scratch_term

      $scratchpadsize = size 80% 85%

      $scratch_term = class:^(scratch_term)$
      windowrulev2 = float,$scratch_term
      windowrulev2 = $scratchpadsize,$scratch_term
      windowrulev2 = workspace special:scratch_term ,$scratch_term
      windowrulev2 = center,$scratch_term

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

      plugin {
        hyprexpo {
          columns = 3
          gap_size = 5
          bg_col = rgb(''+config.lib.stylix.colors.base00+'')
          workspace_method = first 1 # [center/first] [workspace] e.g. first 1 or center m+1
          enable_gesture = false # laptop touchpad
        }
        touch_gestures {
          sensitivity = 4.0
          long_press_delay = 260
          hyprgrass-bind = , edge:r:l, exec, hyprnome
          hyprgrass-bind = , edge:l:r, exec, hyprnome --previous

          hyprgrass-bind = , swipe:3:u, hyprexpo:expo, toggleoverview

          hyprgrass-bind = , swipe:3:l, exec, hyprnome --previous
          hyprgrass-bind = , swipe:3:r, exec, hyprnome

          hyprgrass-bind = , swipe:4:u, movewindow,u
          hyprgrass-bind = , swipe:4:d, movewindow,d
          hyprgrass-bind = , swipe:4:l, movewindow,l
          hyprgrass-bind = , swipe:4:r, movewindow,r

          hyprgrass-bind = , tap:3, fullscreen,1
          hyprgrass-bind = , tap:4, fullscreen,0

          hyprgrass-bindm = , longpress:2, movewindow
          hyprgrass-bindm = , longpress:3, resizewindow
        }
      }

      input {
        kb_layout = be
        repeat_delay = 350
        repeat_rate = 50
        accel_profile = adaptive
        numlock_by_default = true

        touchpad {
          natural_scroll = yes
          disable_while_typing = false
        }
      }

      gestures {
        workspace_swipe = true
        workspace_swipe_cancel_ratio = 0.15
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
    kdePackages.ark
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
    hyprnome
    hyprlock
    fnott
    playerctl

    hyprlandPlugins.hyprgrass
    hyprlandPlugins.hyprexpo

    networkmanagerapplet
    blueman

    pavucontrol
    pamixer
    xdg-utils
  ];

  services.playerctld.enable = true;
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
