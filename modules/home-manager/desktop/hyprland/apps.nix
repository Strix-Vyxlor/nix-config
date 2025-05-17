{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.desktop.hyprland;
  styleCfg = config.strixos.style;
  browserCfg = config.strixos.programs.browser;

  nullOrEnum = list: types.nullOr (types.enum list);
in {
  imports = [
    ./waybar.nix
  ];

  options.strixos.desktop.hyprland.apps = {
    terminal = mkOption {
      type = nullOrEnum [
        "kitty"
      ];
      default = "kitty";
      description = ''
        the default terminal to launch with gui+t
      '';
    };
    launcher = mkOption {
      type = nullOrEnum [
        "tofi"
      ];
      default = "tofi";
      description = ''
        the default launcher to launch with gui+r
      '';
    };
    archiver = mkOption {
      type = nullOrEnum ["xarchiver"];
      default = "xarchiver";
    };
    wallpaper = mkOption {
      type = nullOrEnum [
        "swww"
        "hyprpaper"
      ];
      default = "hyprpaper";
      description = ''
        wallpaper engine to use
      '';
    };
    notification = mkOption {
      type = nullOrEnum [
        "fnott"
      ];
      default = "fnott";
      description = ''
        notification deamon
      '';
    };
    idle = mkOption {
      type = nullOrEnum [
        "hypridle"
      ];
      default = "hypridle";
      description = ''
        idle manager to use
      '';
    };
    lock = mkOption {
      type = nullOrEnum [
        "hyprlock"
      ];
      default = "hyprlock";
      description = ''
        lock screen to use
      '';
    };
    osd = mkOption {
      type = nullOrEnum ["swayosd"];
      default = "swayosd";
      description = ''
        osd to use
      '';
    };
    filemanager = mkOption {
      type = nullOrEnum ["nautilus"];
      default = "nautilus";
      description = ''
        filemanager to use
      '';
    };
    statusbar = mkOption {
      type = nullOrEnum ["waybar"];
      default = "waybar";
      description = ''
        status bar to use
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # NOTE: terminal
    {
      wayland.windowManager.hyprland.settings = {
        "$scratch_term" = "class:^(scratch_term)$";
        bind = [
          "SUPER, T, exec, ${cfg.apps.terminal}"
          "SUPER,Z,exec,if hyprctl clients | grep scratch_term; then echo \"scratch_term respawn not needed\"; else kitty --class scratch_term; fi"
          "SUPER,Z,togglespecialworkspace,scratch_term"
        ];
        windowrulev2 = [
          "float,$scratch_term"
          "$scratchpadsize,$scratch_term"
          "workspace special:scratch_term ,$scratch_term"
          "center,$scratch_term"
        ];
        layerrule = ["blur,kitty"];
        blurls = ["kitty"];
      };
    }
    # launcher
    (mkIf (cfg.apps.launcher == "tofi") {
      wayland.windowManager.hyprland.settings = {
        bind = ["SUPER, R, exec, tofi-drun | xargs hyprctl dispatch exec --"];
      };
    })
    # archiver
    (mkIf (cfg.apps.archiver == "xarchiver") {
      home.packages = [pkgs.xarchiver];
      xdg.mimeApps = {
        defaultApplications = {
          "application/zip" = "xarchiver.desktop";
          "application/x-compressed-tar" = "xarchiver.desktop";
          "application/x-xz-compressed-tar" = "xarchiver.desktop";
          "application/x-bzip2-compressed-tar" = "xarchiver.desktop";
          "application/x-tar" = "xarchiver.desktop";
        };
        associations = {
          added = {
            "application/zip" = "xarchiver.desktop";
            "application/x-compressed-tar" = "xarchiver.desktop";
            "application/x-xz-compressed-tar" = "xarchiver.desktop";
            "application/x-bzip2-compressed-tar" = "xarchiver.desktop";
            "application/x-tar" = "xarchiver.desktop";
          };
        };
      };
    })

    # NOTE: wallpaper
    (mkIf (cfg.apps.wallpaper == "hyprpaper") {
      services.hyprpaper.enable = true;
      stylix.targets.hyprpaper.enable = true;

      # WARN: the service seems to crash
      wayland.windowManager.hyprland.settings = {
        exec-once = ["systemctl --user start hyprpaper"];
      };
    })
    (mkIf (cfg.apps.wallpaper == "swww") {
      services.swww.enable = true;

      wayland.windowManager.hyprland.settings = {
        exec-once = ["systemctl --user start swww-daemon"];
      };
    })

    # NOTE: notification
    (mkIf (cfg.apps.notification == "fnott") {
      services.fnott = {
        enable = true;
        settings = {
          main = {
            anchor = "top-right";
            stacking-order = "top-down";
            min-width = 400;
            title-font = styleCfg.desktop.font.default.name + ":size=14";
            summary-font = styleCfg.desktop.font.default.name + ":size=12";
            body-font = styleCfg.desktop.font.default.name + ":size=11";
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
      };
    })
    # NOTE: idle
    (mkIf (cfg.apps.idle == "hypridle") {
      services.hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = mkIf (cfg.apps.lock != null) "${cfg.apps.lock}";
            before_sleep_cmd = "loginctl lock-session";
            ignore_dbus_inhibit = false;
          };

          listener = [
            {
              timeout = 270;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
            (mkIf (cfg.apps.lock != null) {
              timeout = 300;
              on-timeout = "loginctl lock-session";
            })
          ];
        };
      };

      wayland.windowManager.hyprland.settings = {
        exec-once = ["systemctl --user start hypridle"];
      };
    })

    # NOTE: lock
    (mkIf (cfg.apps.lock == "hyprlock") {
      programs.hyprlock = {
        enable = true;
        settings = {
          background = {
            path = "screenshot";
            blur_passes = 4;
            blur_size = 5;
            noise = 0.0117;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          };
          input-field = {
            size = "200, 50";
            outline_thickness = 3;
            dots_size = 0.33;
            dots_spacing = 0.15;
            dots_center = false;
            dots_rounding = -1;
            outer_color =
              ''rgb(''
              + config.lib.stylix.colors.base07-rgb-r
              + '',''
              + config.lib.stylix.colors.base07-rgb-g
              + '',''
              + config.lib.stylix.colors.base07-rgb-b
              + '')'';
            inner_color =
              ''rgb(''
              + config.lib.stylix.colors.base00-rgb-r
              + '',''
              + config.lib.stylix.colors.base00-rgb-g
              + '',''
              + config.lib.stylix.colors.base00-rgb-b
              + '')'';
            font_color =
              ''rgb(''
              + config.lib.stylix.colors.base07-rgb-r
              + '',''
              + config.lib.stylix.colors.base07-rgb-g
              + '',''
              + config.lib.stylix.colors.base07-rgb-b
              + '')'';
            fade_on_empty = true;
            fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
            placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
            hide_input = false;
            rounding = -1; # -1 means complete rounding (circle/oval)
            check_color =
              ''rgb(''
              + config.lib.stylix.colors.base0A-rgb-r
              + '',''
              + config.lib.stylix.colors.base0A-rgb-g
              + '',''
              + config.lib.stylix.colors.base0A-rgb-b
              + '')'';
            fail_color =
              ''rgb(''
              + config.lib.stylix.colors.base08-rgb-r
              + '',''
              + config.lib.stylix.colors.base08-rgb-g
              + '',''
              + config.lib.stylix.colors.base08-rgb-b
              + '')'';
            fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
            fail_transition = 300; # transition time in ms between normal outer_color and fail_color
            capslock_color = -1;
            numlock_color = -1;
            bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
            invert_numlock = false; # change color if numlock is off
            swap_font_color = false; # see below

            position = "0, -20";
            halign = "center";
            valign = "center";
          };

          label = {
            text = "Hello, ${config.strixos.user.name};";
            color =
              ''rgb(''
              + config.lib.stylix.colors.base07-rgb-r
              + '',''
              + config.lib.stylix.colors.base07-rgb-g
              + '',''
              + config.lib.stylix.colors.base07-rgb-b
              + '')'';
            font_size = 25;
            font_family = styleCfg.desktop.font.default.name;

            rotate = 0; # degrees, counter-clockwise

            position = "0, 160";
            halign = "center";
            valign = "center";
          };
        };
      };
    })
    # NOTE: osd
    (mkIf (cfg.apps.osd == "swayosd") {
      services.swayosd = {
        enable = true;
        topMargin = 0.5;
      };

      wayland.windowManager.hyprland.settings = {
        exec-once = ["swayosd-server"];
        bind = [
          ",XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
          ",XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
          ",XF86AudioLowerVolume, exec, swayosd-client --output-volume lower"
          ",XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise"
          ",XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
          ",XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
        ];
      };
    })
    # NOTE: filemanager
    (mkIf (cfg.apps.filemanager == "nautilus") {
      home.packages = with pkgs; [
        nautilus
        udiskie
        udisks
      ];
      wayland.windowManager.hyprland.settings = {
        bind = ["SUPER, F, exec, nautilus"];
        windowrulev2 = ["opacity 0.85,class:^(org.gnome.Nautilus)$"];
      };
    })
    # NOTE: browser
    (mkIf (config.lib.strixos.programs.defaultBrowser != null) {
      wayland.windowManager.hyprland.settings = {
        bind = ["SUPER, B, exec, ${config.lib.strixos.programs.defaultBrowser}"];
      };
    })
  ]);
}
