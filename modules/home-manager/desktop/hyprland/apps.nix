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

  # swaync-css = pkgs.runCommand "swaync-style" {} ''
  #   mkdir -p $out
  #   ${pkgs.sassc}/bin/sassc ${config.lib.stylix.colors {
  #     template = ./confFiles/swaync.scss.mustache;
  #     extension = ".scss";
  #   }} $out/style.css
  # '';
  swaync-css = pkgs.writeTextFile {
    name = "swaync-style";
    text = ''${config.lib.stylix.colors {
        template = ./confFiles/swaync.css.mustache;
        extension = ".css";
      }}'';
    destination = "/style.css";
  };

  swayosd-css = pkgs.runCommand "swayosd-style" {} ''
    mkdir -p $out
    ${pkgs.sassc}/bin/sassc ${config.lib.stylix.colors {
      template = ./confFiles/swayosd.scss.mustache;
      extension = ".scss";
    }} $out/style.css
  '';
in {
  imports = [
    ./waybar
    ./waybar/alt.nix
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
        "wofi"
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
        "swaync"
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
      type = nullOrEnum ["standalone" "swayosd"];
      default = "standalone";
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
      type = nullOrEnum [
        "waybar"
        "waybar-alt"
      ];
      default = "waybar";
      description = ''
        status bar to use
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    # SECTION: terminal
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
    #  SECTION: launcher
    (mkIf (cfg.apps.launcher == "tofi") {
      wayland.windowManager.hyprland.settings = {
        bind = ["SUPER, R, exec, tofi-drun | xargs hyprctl dispatch exec --"];
      };
    })
    (mkIf (cfg.apps.launcher == "wofi") {
      wayland.windowManager.hyprland.settings = {
        bind = ["SUPER, R, exec, wofi"];
        layerrule = [
          "blur,wofi"
          "ignorezero, wofi"
          "ignorealpha 0.5, wofi"
        ];
      };
      programs.wofi = {
        enable = true;
        settings = {
          mode = "drun";
          width = "500";
          height = "400";
          prompt = "Search";
          allow_images = true;
        };
        style = with config.lib.stylix.colors; ''
          @define-color base01 #${base01};
          @define-color base0D  #${base0D};
          @define-color base05  #${base05};
          @keyframes fadeIn {
              0% {
              }
              100% {
              }
          }

          * {
              all:unset;
              font-family: "${styleCfg.desktop.font.monospace.name}", monospace;
              font-size: 18px;
              outline: none;
              border: none;
              text-shadow:none;
              background-color:transparent;
          }

          window {
              all:unset;
              padding: 20px;
              border-radius: 15px;
              background-color: alpha(@base01,.5);
              border-color: @base0D;
              border-width: 3px;
          }
          #inner-box {
              margin: 2px;
              padding: 5px
              border: none;
          }
          #outer-box {
              border: none;
          }
          #scroll {
              margin: 0px;
              padding: 30px;
              border: none;
          }
          #input {
              all:unset;
              margin-left:20px;
              margin-right:20px;
              margin-top:20px;
              padding: 20px;
              border: none;
              outline: none;
              color: @base05;
              box-shadow: 1px 1px 5px rgba(0,0,0, .5);
              border-radius:10;
              background-color: alpha(@base01,.2);
          }
          #input image {
              border: none;
              color: @base0D;
              padding-right:10px;
          }
          #input * {
              border: none;
              outline: none;
          }

          #input:focus {
              outline: none;
              border: none;

              border-radius:10;
          }
          #text {
              margin: 5px;
              border: none;
              color: @base05;
              outline: none;
          }
          #text {
              margin: 5px;
              border: none;
              color: @base05;
              outline: none;
          }
          #entry {
              border: none;
              margin: 5px;
              padding: 10px;
          }
          #entry arrow {
              border: none;
              color: @base0D;

          }
          #entry:selected {
              box-shadow: 1px 1px 5px rgba(255,255,255, .03);
              border: none;
              border-radius: 20px;
              background-color:transparent;
          }
          #entry:selected #text {
              color: @base0D;
          }
          #entry:drop(active) {
              background-color: @base0D !important;
          }

        '';
      };
    })
    # SECTION: archiver
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

      wayland.windowManager.hyprland.settings.windowrulev2 = ["opacity 0.85,class:^(xarchiver)$"];
    })

    # SECTION: wallpaper
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

    # SECTION: notification
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
    (mkIf (cfg.apps.notification == "swaync") {
      services.swaync = {
        enable = true;
        settings = {
          layer = "overlay";
          control-center-layer = "top";
          layer-shell = true;
          widgets = [
            "title"
            "notifications"
            "mpris"
          ];
        };
        style = builtins.readFile "${swaync-css}/style.css";
      };

      wayland.windowManager.hyprland.settings = {
        exec-once = [
          "systemctl restart --user swaync"
        ];

        bind = ["SUPER, N, exec, swaync-client -t -sw"];
        layerrule = [
          "blur,swaync-control-center"
          "blur,swaync-notification-window"
          "ignorezero, swaync-control-center"
          "ignorezero, swaync-notification-window"
          "ignorealpha 0.5, swaync-control-center"
          "ignorealpha 0.5, swaync-notification-window"
        ];
      };
    })
    # SECTION: idle
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

    # SECTION: lock
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

          label = [
            {
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
            }
            {
              text = "$TIME";
              color =
                ''rgb(''
                + config.lib.stylix.colors.base07-rgb-r
                + '',''
                + config.lib.stylix.colors.base07-rgb-g
                + '', ''
                + config.lib.stylix.colors.base07-rgb-b
                + '')'';
              font_size = 20;
              font_family = styleCfg.desktop.font.default.name;
              rotate = 0;

              position = "0, 80";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };
    })
    # SECTION: osd
    (mkIf (cfg.apps.osd == "standalone") {
      home.packages = with pkgs; [
        brightnessctl
      ];
      wayland.windowManager.hyprland.settings = {
        bind = [
          ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
          ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
          ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ];
      };
    })
    (mkIf (cfg.apps.osd == "swayosd") {
      services.swayosd = {
        enable = true;
        topMargin = 0.5;
        stylePath = "${swayosd-css}/style.css";
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
        layerrule = [
          "blur,swayosd"
          "ignorezero, swayosd"
          "ignorealpha 0.5, swayosd"
        ];
      };
    })
    # SECTION: filemanager
    (mkIf (cfg.apps.filemanager == "nautilus") {
      home.packages = with pkgs; [
        nautilus
        udiskie
        udisks
      ];
      wayland.windowManager.hyprland.settings = {
        bind = ["SUPER, F, exec, nautilus"];
        windowrulev2 = ["opacity 0.80,class:^(org.gnome.Nautilus)$"];
      };
    })
    # SECTION: browser
    (mkIf (config.lib.strixos.defaultBrowser != null) {
      wayland.windowManager.hyprland.settings = {
        bind = ["SUPER, B, exec, ${config.lib.strixos.defaultBrowser}"];
      };
    })
  ]);
}
