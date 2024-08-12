{ pkgs, config, lib, userSettings, ... }:
{
  imports = [
    ../../app/term/alacritty.nix
    ../../app/launcher/tofi.nix
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

      bind=SUPER,H,movefocus,l
      bind=SUPER,J,movefocus,d
      bind=SUPER,K,movefocus,u
      bind=SUPER,L,movefocus,r

      bind=SUPERSHIFT,H,movewindow,l
      bind=SUPERSHIFT,J,movewindow,d
      bind=SUPERSHIFT,K,movewindow,u
      bind=SUPERSHIFT,L,movewindow,r

      layerrule = blur,alacritty
      layerrule = xray,alacritty
      blurls = alacritty

      monitor=eDP-1,1920x1200,0x0x,1
      monitor=HDMI-A-1,1920x1080,-1920x0,1

      input {
        kb_layout = be
        repeat_delay = 350
        repeat_rate = 50
        accel_profile = adaptive
        follow_mouse = 2
        float_switch_override_focus = 0
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

    pavucontrol
    pamixer
    xdg-utils
  ];

  home.file.".config/hypr/hypridle.conf".text = ''
    general {
      lock_cmd = pgrep hyprlock || hyprlock
      before_sleep_cmd = loginctl lock-session
      ignore_dbus_inhibit = false
    }

    listener {
      timeout = 150 # in seconds
      on-timeout = hyprctl dispatch dpms off
      on-resume = hyprctl dispatch dpms on
    }
    listener {
      timeout = 160 # in seconds
      on-timeout = loginctl lock-session
    }
    listener {
      timeout = 5400 # in seconds
      on-timeout = systemctl suspend
      on-resume = hyprctl dispatch dpms on
    }
  '';

  home.file.".config/hypr/hyprlock.conf".text = ''
    background {
      monitor =
      path = screenshot

      # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
      blur_passes = 4
      blur_size = 5
      noise = 0.0117
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
    }

    input-field {
      monitor =
      size = 200, 50
      outline_thickness = 3
      dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = false
      dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
      outer_color = rgb(''+config.lib.stylix.colors.base07-rgb-r+'',''+config.lib.stylix.colors.base07-rgb-g+'', ''+config.lib.stylix.colors.base07-rgb-b+'')
      inner_color = rgb(''+config.lib.stylix.colors.base00-rgb-r+'',''+config.lib.stylix.colors.base00-rgb-g+'', ''+config.lib.stylix.colors.base00-rgb-b+'')
      font_color = rgb(''+config.lib.stylix.colors.base07-rgb-r+'',''+config.lib.stylix.colors.base07-rgb-g+'', ''+config.lib.stylix.colors.base07-rgb-b+'')
      fade_on_empty = true
      fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
      placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
      hide_input = false
      rounding = -1 # -1 means complete rounding (circle/oval)
      check_color = rgb(''+config.lib.stylix.colors.base0A-rgb-r+'',''+config.lib.stylix.colors.base0A-rgb-g+'', ''+config.lib.stylix.colors.base0A-rgb-b+'')
      fail_color = rgb(''+config.lib.stylix.colors.base08-rgb-r+'',''+config.lib.stylix.colors.base08-rgb-g+'', ''+config.lib.stylix.colors.base08-rgb-b+'')
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
      fail_transition = 300 # transition time in ms between normal outer_color and fail_color
      capslock_color = -1
      numlock_color = -1
      bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false # change color if numlock is off
      swap_font_color = false # see below

      position = 0, -20
      halign = center
      valign = center
    }

    label {
      monitor =
      text = Hello, Emmet
      color = rgb(''+config.lib.stylix.colors.base07-rgb-r+'',''+config.lib.stylix.colors.base07-rgb-g+'', ''+config.lib.stylix.colors.base07-rgb-b+'')
      font_size = 25
      font_family = ''+userSettings.font+''

      rotate = 0 # degrees, counter-clockwise

      position = 0, 160
      halign = center
      valign = center
    }

    label {
      monitor =
      text = $TIME
      color = rgb(''+config.lib.stylix.colors.base07-rgb-r+'',''+config.lib.stylix.colors.base07-rgb-g+'', ''+config.lib.stylix.colors.base07-rgb-b+'')
      font_size = 20
      font_family = Intel One Mono
      rotate = 0 # degrees, counter-clockwise

      position = 0, 80
      halign = center
      valign = center
    }
  '';

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: {
      postPatch = ''
        # use hyprctl to switch workspaces
        sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch focusworkspaceoncurrentmonitor " + std::to_string(id());\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
        sed -i 's/gIPC->getSocket1Reply("dispatch workspace " + std::to_string(id()));/gIPC->getSocket1Reply("dispatch focusworkspaceoncurrentmonitor " + std::to_string(id()));/g' src/modules/hyprland/workspaces.cpp
      '';
      patches = [./patches/waybarpaupdate.patch ./patches/waybarbatupdate.patch];
    });
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        margin = "7 7 3 7";
        spacing = 2;

        modules-left = [ "group/power" "group/battery" "group/backlight" "group/cpu" "group/memory" "group/pulseaudio" "keyboard-state" ];
        modules-center = [ "custom/hyprprofile" "hyprland/workspaces" ];
        modules-right = [ "group/time" "idle_inhibitor" "tray" ];

        "custom/os" = {
          "format" = " {} ";
          "exec" = ''echo "" '';
          "interval" = "once";
          "on-click" = "nwggrid-wrapper";
          "tooltip" = false;
        };
        "group/power" = {
            "orientation" = "horizontal";
            "drawer" = {
                "transition-duration" = 500;
                "children-class" = "not-power";
                "transition-left-to-right" = true;
            };
            "modules" = [
                "custom/os"
                "custom/hyprprofileicon"
                "custom/lock"
                "custom/quit"
                "custom/power"
                "custom/reboot"
            ];
        };
        "custom/quit" = {
            "format" = "󰍃";
            "tooltip" = false;
            "on-click" = "hyprctl dispatch exit";
        };
        "custom/lock" = {
            "format" = "󰍁";
            "tooltip" = false;
            "on-click" = "hyprlock";
        };
        "custom/reboot" = {
            "format" = "󰜉";
            "tooltip" = false;
            "on-click" = "reboot";
        };
        "custom/power" = {
            "format" = "󰐥";
            "tooltip" = false;
            "on-click" = "shutdown now";
        };
        "custom/hyprprofileicon" = {
          "format" = "󱙋";
          "on-click" = "hyprprofile-dmenu";
          "tooltip" = false;
        };
        "custom/hyprprofile" = {
          "format" = " {}";
          "exec" = ''cat ~/.hyprprofile'';
          "interval" = 3;
          "on-click" = "hyprprofile-dmenu";
        };
        "keyboard-state" = {
          "numlock" = true;
          "format" = "{icon}";
          "format-icons" = {
            "locked" = "󰎠 ";
            "unlocked" = "󱧓 ";
          };
        };
        "hyprland/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "󱚌";
            "2" = "󰖟";
            "3" = "";
            "4" = "󰎄";
            "5" = "󰋩";
            "6" = "";
            "7" = "󰄖";
            "8" = "󰑴";
            "9" = "󱎓";
            "scratch_term" = "_";
            "scratch_ranger" = "_󰴉";
            "scratch_music" = "_";
            "scratch_btm" = "_";
            "scratch_pavucontrol" = "_󰍰";
          };
          "on-click" = "activate";
          "on-scroll-up" = "hyprnome";
          "on-scroll-down" = "hyprnome --previous";
          "all-outputs" = false;
          "active-only" = false;
          "ignore-workspaces" = ["scratch" "-"];
          "show-special" = false;
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };
        tray = {
          #"icon-size" = 21;
          "spacing" = 10;
        };
        "clock#time" = {
          "interval" = 1;
          "format" = "{:%I:%M:%S %p}";
          "timezone" = "America/Chicago";
          "tooltip-format" = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "clock#date" = {
          "interval" = 1;
          "format" = "{:%a %Y-%m-%d}";
          "timezone" = "America/Chicago";
          "tooltip-format" = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        "group/time" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = false;
          };
          "modules" = [ "clock#time" "clock#date" ];
        };

        cpu = { "format" = "󰍛"; };
        "cpu#text" = { "format" = "{usage}%"; };
        "group/cpu" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "cpu" "cpu#text" ];
        };

        memory = { "format" = ""; };
        "memory#text" = { "format" = "{}%"; };
        "group/memory" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "memory" "memory#text" ];
        };

        backlight = {
          "format" = "{icon}";
          "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
        };
        "backlight#text" = { "format" = "{percent}%"; };
        "group/backlight" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "backlight" "backlight#text" ];
        };

        battery = {
          "states" = {
            "good" = 75;
            "warning" = 30;
            "critical" = 15;
          };
          "fullat" = 80;
          "format" = "{icon}";
          "format-charging" = "󰂄";
          "format-plugged" = "󰂄";
          "format-full" = "󰁹";
          "format-icons" = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          "interval" = 10;
        };
        "battery#text" = {
          "states" = {
            "good" = 75;
            "warning" = 30;
            "critical" = 15;
          };
          "fullat" = 80;
          "format" = "{capacity}%";
        };
        "group/battery" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "battery" "battery#text" ];
        };
        pulseaudio = {
          "scroll-step" = 1;
          "format" = "{icon}";
          "format-bluetooth" = "{icon}";
          "format-bluetooth-muted" = "󰸈";
          "format-muted" = "󰸈";
          "format-source" = "";
          "format-source-muted" = "";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "" ];
          };
          "on-click" = "pypr toggle pavucontrol && hyprctl dispatch bringactivetotop";
        };
        "pulseaudio#text" = {
          "scroll-step" = 1;
          "format" = "{volume}%";
          "format-bluetooth" = "{volume}%";
          "format-bluetooth-muted" = "";
          "format-muted" = "";
          "format-source" = "{volume}%";
          "format-source-muted" = "";
          "on-click" = "pypr toggle pavucontrol && hyprctl dispatch bringactivetotop";
        };
        "group/pulseaudio" = {
          "orientation" = "horizontal";
          "drawer" = {
            "transition-duration" = 500;
            "transition-left-to-right" = true;
          };
          "modules" = [ "pulseaudio" "pulseaudio#text" ];
        };
      };
    };
    style = ''
      * {
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: FontAwesome, ''+userSettings.font+'';

          font-size: 20px;
      }

      window#waybar {
          background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.55);
          border-radius: 8px;
          color: #'' + config.lib.stylix.colors.base07 + '';
          transition-property: background-color;
          transition-duration: .2s;
      }

      tooltip {
        color: #'' + config.lib.stylix.colors.base07 + '';
        background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.9);
        border-style: solid;
        border-width: 3px;
        border-radius: 8px;
        border-color: #'' + config.lib.stylix.colors.base08 + '';
      }

      tooltip * {
        color: #'' + config.lib.stylix.colors.base07 + '';
        background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.0);
      }

      window > box {
          border-radius: 8px;
          opacity: 0.94;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      button {
          border: none;
      }

      #custom-hyprprofile {
          color: #'' + config.lib.stylix.colors.base0D + '';
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      button:hover {
          background: inherit;
      }

      #workspaces button {
          padding: 0px 6px;
          background-color: transparent;
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      #workspaces button:hover {
          color: #'' + config.lib.stylix.colors.base07 + '';
      }

      #workspaces button.active {
          color: #'' + config.lib.stylix.colors.base08 + '';
      }

      #workspaces button.focused {
          color: #'' + config.lib.stylix.colors.base0A + '';
      }

      #workspaces button.visible {
          color: #'' + config.lib.stylix.colors.base05 + '';
      }

      #workspaces button.urgent {
          color: #'' + config.lib.stylix.colors.base09 + '';
      }

      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #custom-hyprprofileicon,
      #custom-quit,
      #custom-lock,
      #custom-reboot,
      #custom-power,
      #mpd {
          padding: 0 3px;
          color: #'' + config.lib.stylix.colors.base07 + '';
          border: none;
          border-radius: 8px;
      }

      #custom-hyprprofileicon,
      #custom-quit,
      #custom-lock,
      #custom-reboot,
      #custom-power,
      #idle_inhibitor {
          background-color: transparent;
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      #custom-hyprprofileicon:hover,
      #custom-quit:hover,
      #custom-lock:hover,
      #custom-reboot:hover,
      #custom-power:hover,
      #idle_inhibitor:hover {
          color: #'' + config.lib.stylix.colors.base07 + '';
      }

      #clock, #tray, #idle_inhibitor {
          padding: 0 5px;
      }

      #window,
      #workspaces {
          margin: 0 6px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
      }

      #clock {
          color: #'' + config.lib.stylix.colors.base0D + '';
      }

      #battery {
          color: #'' + config.lib.stylix.colors.base0B + '';
      }

      #battery.charging, #battery.plugged {
          color: #'' + config.lib.stylix.colors.base0C + '';
      }

      @keyframes blink {
          to {
              background-color: #'' + config.lib.stylix.colors.base07 + '';
              color: #'' + config.lib.stylix.colors.base00 + '';
          }
      }

      #battery.critical:not(.charging) {
          background-color: #'' + config.lib.stylix.colors.base08 + '';
          color: #'' + config.lib.stylix.colors.base07 + '';
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      label:focus {
          background-color: #'' + config.lib.stylix.colors.base00 + '';
      }

      #cpu {
          color: #'' + config.lib.stylix.colors.base0D + '';
      }

      #memory {
          color: #'' + config.lib.stylix.colors.base0E + '';
      }

      #disk {
          color: #'' + config.lib.stylix.colors.base0F + '';
      }

      #backlight {
          color: #'' + config.lib.stylix.colors.base0A + '';
      }

      label.numlock {
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      label.numlock.locked {
          color: #'' + config.lib.stylix.colors.base0F + '';
      }

      #pulseaudio {
          color: #'' + config.lib.stylix.colors.base0C + '';
      }

      #pulseaudio.muted {
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
      }

      #idle_inhibitor {
          color: #'' + config.lib.stylix.colors.base04 + '';
      }

      #idle_inhibitor.activated {
          color: #'' + config.lib.stylix.colors.base0F + '';
      }
      '';
  };
  home.file.".config/gtklock/style.css".text = ''
    window {
      background-image: url("''+config.stylix.image+''");
      background-size: auto 100%;
    }
  '';
  home.file.".config/nwg-launchers/nwggrid/style.css".text = ''
    button, label, image {
        background: none;
        border-style: none;
        box-shadow: none;
        color: #'' + config.lib.stylix.colors.base07 + '';

        font-size: 20px;
    }

    button {
        padding: 5px;
        margin: 5px;
        text-shadow: none;
    }

    button:hover {
        background-color: rgba('' + config.lib.stylix.colors.base07-rgb-r + "," + config.lib.stylix.colors.base07-rgb-g + "," + config.lib.stylix.colors.base07-rgb-b + "," + ''0.15);
    }

    button:focus {
        box-shadow: 0 0 10px;
    }

    button:checked {
        background-color: rgba('' + config.lib.stylix.colors.base07-rgb-r + "," + config.lib.stylix.colors.base07-rgb-g + "," + config.lib.stylix.colors.base07-rgb-b + "," + ''0.15);
    }

    #searchbox {
        background: none;
        border-color: #'' + config.lib.stylix.colors.base07 + '';

        color: #'' + config.lib.stylix.colors.base07 + '';

        margin-top: 20px;
        margin-bottom: 20px;

        font-size: 20px;
    }

    #separator {
        background-color: rgba('' + config.lib.stylix.colors.base00-rgb-r + "," + config.lib.stylix.colors.base00-rgb-g + "," + config.lib.stylix.colors.base00-rgb-b + "," + ''0.55);

        color: #'' + config.lib.stylix.colors.base07 + '';
        margin-left: 500px;
        margin-right: 500px;
        margin-top: 10px;
        margin-bottom: 10px
    }

    #description {
        margin-bottom: 20px
    }
  '';

  services.fnott.enable = true;
  services.fnott.settings = {
    main = {
      anchor = "bottom-right";
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
}
