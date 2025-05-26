{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.desktop.hyprland;
  styleCfg = config.strixos.style;
in {
  imports = [
    ./apps.nix
    ./plugins.nix
  ];

  options.strixos.desktop.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable custom hyprland config
      '';
    };
    hyprcursorTheme = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        name of the hyprcursor theme
      '';
    };
    keymap = mkOption {
      type = types.str;
      default = "us";
      description = ''
        keymap to use
      '';
    };
    extraSettings = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        extra settings to pass to hyprland
      '';
    };
    monitors = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        list of monitor configurations
      '';
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      settings = mkMerge [
        {
          "$scratchpadsize" = "size 80% 85%";
          env = [
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "GDK_BACKEND,wayland,x11,*"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_QPA_PLATFORMTHEME,qt5ct"
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
            "CLUTTER_BACKEND,wayland"
            "XCURSOR_THEME,${styleCfg.desktop.cursor.name}"
            "XCURSOR_SIZE,${builtins.toString styleCfg.desktop.cursor.size}"
          ];

          bind = [
            "SUPER, Q, killactive"

            "SUPER, Left, movefocus, l"
            "SUPER, Down, movefocus, d"
            "SUPER, Up, movefocus, u"
            "SUPER, Right, movefocus, r"
            "SUPER_CTRL, Left, movewindow, l"
            "SUPER_CTRL, Down, movewindow, d"
            "SUPER_CTRL, Up, movewindow, u"
            "SUPER_CTRL, Right, movewindow, r"

            "SUPER, ampersand, focusworkspaceoncurrentmonitor, 1"
            "SUPER, eacute, focusworkspaceoncurrentmonitor, 2"
            "SUPER, quotedbl, focusworkspaceoncurrentmonitor, 3"
            "SUPER, apostrophe, focusworkspaceoncurrentmonitor, 4"
            "SUPER, parenleft, focusworkspaceoncurrentmonitor, 5"
            "SUPER, section, focusworkspaceoncurrentmonitor, 6"
            "SUPER, egrave, focusworkspaceoncurrentmonitor, 7"
            "SUPER, exclam, focusworkspaceoncurrentmonitor, 8"
            "SUPER, ccedilla, focusworkspaceoncurrentmonitor, 9"
            "SUPERSHIFT, ampersand, movetoworkspace, 1"
            "SUPERSHIFT, eacute, movetoworkspace, 2"
            "SUPERSHIFT, quotedbl, movetoworkspace, 3"
            "SUPERSHIFT, apostrophe, movetoworkspace, 4"
            "SUPERSHIFT, parenleft, movetoworkspace, 5"
            "SUPERSHIFT, section, movetoworkspace, 6"
            "SUPERSHIFT, egrave, movetoworkspace, 7"
            "SUPERSHIFT, exclam, movetoworkspace, 8"
            "SUPERSHIFT, ccedilla, movetoworkspace, 9"

            ",XF86AudioNext, exec, playerctl next"
            ",XF86AudioPrev, exec, playerctl previous"
            ",XF86AudioPlay, exec, playerctl play-pause"
            ",XF86AudioPause, exec, playerctl play-pause"
          ];

          bindm = [
            "SUPER, mouse:272, movewindow"
            "SUPER, mouse:273, resizewindow"
          ];

          exec-once =
            lib.lists.optionals (cfg.hyprcursorTheme != null) ["hyprctl setcursor ${cfg.hyprcursorTheme} ${builtins.toString styleCfg.desktop.cursor.size}"];

          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.0"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
            "linear, 0.0, 0.0, 1.0, 1.0"
          ];

          animations = {
            enabled = "yes";
            animation = [
              "windowsIn, 1, 6, winIn, popin"
              "windowsOut, 1, 5, winOut, popin"
              "windowsMove, 1, 5, wind, slide"
              "border, 1, 10, default"
              "borderangle, 1, 100, linear, loop"
              "fade, 1, 10, default"
              "workspaces, 1, 5, wind"
              "windows, 1, 6, wind, slide"
            ];
          };

          general = {
            layout = "dwindle";
            border_size = 5;
            gaps_in = 5;
            gaps_out = 5;
            "col.active_border" =
              ''0xff''
              + config.lib.stylix.colors.base08
              + " "
              + ''0xff''
              + config.lib.stylix.colors.base09
              + " "
              + ''0xff''
              + config.lib.stylix.colors.base0A
              + " "
              + ''0xff''
              + config.lib.stylix.colors.base0B
              + " "
              + ''0xff''
              + config.lib.stylix.colors.base0C
              + " "
              + ''0xff''
              + config.lib.stylix.colors.base0D
              + " "
              + ''0xff''
              + config.lib.stylix.colors.base0E
              + " "
              + ''0xff''
              + config.lib.stylix.colors.base0F
              + " 270deg";
            "col.inactive_border" =
              ''0xaa''
              + config.lib.stylix.colors.base00
              + " "
              + ''0xaa''
              + config.lib.stylix.colors.base01
              + " "
              + ''0xaa''
              + config.lib.stylix.colors.base02
              + " "
              + ''0xaa''
              + config.lib.stylix.colors.base03
              + " 270deg";
          };
          cursor.inactive_timeout = 30;

          input = {
            kb_layout = cfg.keymap;
            repeat_delay = 350;
            repeat_rate = 50;
            accel_profile = "linear";
            numlock_by_default = true;

            touchpad = {
              natural_scroll = "yes";
              disable_while_typing = false;
            };
          };

          gestures = {
            workspace_swipe = true;
            workspace_swipe_cancel_ratio = 0.15;
          };

          decoration = {
            rounding = 8;
            blur = {
              size = 5;
              passes = 2;
              contrast = 1.17;
              brightness =
                if config.stylix.polarity == "dark"
                then 0.8
                else 1.25;
            };
          };

          monitor = cfg.monitors;
        }
        cfg.extraSettings
      ];
    };

    services.playerctld.enable = true;

    home.packages = with pkgs; [
      libva-utils
      libinput-gestures
      gsettings-desktop-schemas
      libsForQt5.qt5.qtwayland
      qt6.qtwayland
      wl-clipboard
      hyprnome
      playerctl
      libappindicator
      xdg-utils
    ];
  };
}
