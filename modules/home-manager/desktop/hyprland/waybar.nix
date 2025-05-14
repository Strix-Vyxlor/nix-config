{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.desktop.hyprland;
  styleCfg = config.strixos.style;
  waybarCfg = cfg.apps.waybar;
in {
  options.strixos.desktop.hyprland.apps.waybar = {
    battery = mkOption {
      type = types.bool;
      default = false;
      description = ''
        device has a battery
      '';
    };
    brightness = mkOption {
      type = types.bool;
      default = false;
      description = ''
        device has a screen with brightness controll
      '';
    };
    temperature = mkOption {
      type = types.bool;
      default = false;
      description = ''
        add temperature sensor reading
      '';
    };
    timezone = mkOption {
      type = types.str;
      default = "Europe/Brussels";
      description = ''
        timezone to use
      '';
    };
  };

  config = mkIf (cfg.apps.statusbar == "waybar") {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 35;
          margin = "7 7 3 7";
          spacing = 2;

          modules-left =
            [
              "group/power"
            ]
            ++ lib.lists.optionals waybarCfg.battery ["group/battery"]
            ++ lib.lists.optionals waybarCfg.brightness ["group/backlight"]
            ++ lib.lists.optionals waybarCfg.temperature ["group/temp"]
            ++ [
              "group/cpu"
              "group/memory"
              "group/pulseaudio"
            ];
          modules-center = ["hyprland/workspaces"];
          modules-right = [
            "group/time"
            "idle_inhibitor"
            "tray"
          ];

          "custom/os" = {
            "format" = " {} ";
            "exec" = ''echo "" '';
            "interval" = "once";
            "on-click" = "";
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
            };
            "on-click" = "activate";
            "on-scroll-up" = "hyprnome";
            "on-scroll-down" = "hyprnome --previous";
            "all-outputs" = false;
            "active-only" = false;
            "ignore-workspaces" = ["scratch" "-"];
            "show-special" = false;
          };

          "group/temp" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 500;
              "transition-left-to-right" = true;
            };
            "modules" = [
              "temperature"
              "temperature#text"
            ];
          };

          temperature = {
            critical-threshold = 80;
            format = "";
          };
          "temperature#text" = {
            format = "{temperatureC}°C";
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
            "timezone" = waybarCfg.timezone;
            "tooltip-format" = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          "clock#date" = {
            "interval" = 1;
            "format" = "{:%a %d %b}";
            "timezone" = "Europe/Brussels";
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
            "modules" = ["clock#time" "clock#date"];
          };

          cpu = {"format" = "󰍛";};
          "cpu#text" = {"format" = "{usage}%";};
          "group/cpu" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 500;
              "transition-left-to-right" = true;
            };
            "modules" = ["cpu" "cpu#text"];
          };

          memory = {"format" = "";};
          "memory#text" = {"format" = "{}%";};
          "group/memory" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 500;
              "transition-left-to-right" = true;
            };
            "modules" = ["memory" "memory#text"];
          };

          backlight = {
            "format" = "{icon}";
            "format-icons" = ["" "" "" "" "" "" "" "" ""];
          };
          "backlight#text" = {"format" = "{percent}%";};
          "group/backlight" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 500;
              "transition-left-to-right" = true;
            };
            "modules" = ["backlight" "backlight#text"];
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
            "format-icons" = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
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
            "modules" = ["battery" "battery#text"];
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
              "headphone" = "󰋋";
              "hands-free" = "󰋎";
              "headset" = "󰋋";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = ["" "" ""];
            };
            "on-click" = "hyprctl dispatch togglespecialworkspace scratch_pwvucontrol; if hyprctl clients | grep pwvucontrol; then echo 'scratch_ranger respawn not needed'; else pwvucontrol; fi";
          };
          "pulseaudio#text" = {
            "scroll-step" = 1;
            "format" = "{volume}%";
            "format-bluetooth" = "{volume}%";
            "format-bluetooth-muted" = "";
            "format-muted" = "";
            "format-source" = "{volume}%";
            "format-source-muted" = "";
            "on-click" = "hyprctl dispatch togglespecialworkspace scratch_pwvucontrol; if hyprctl clients | grep pwvucontrol; then echo 'scratch_ranger respawn not needed'; else pwvucontrol; fi";
          };
          "group/pulseaudio" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 500;
              "transition-left-to-right" = true;
            };
            "modules" = ["pulseaudio" "pulseaudio#text"];
          };
        };
      };
      style =
        ''
          * {
              font-family: FontAwesome, ''
        + styleCfg.desktop.font.monospace.name
        + ''          ;

                    font-size: 20px;
                }

                window#waybar {
                    background-color: rgba(''
        + config.lib.stylix.colors.base00-rgb-r
        + ","
        + config.lib.stylix.colors.base00-rgb-g
        + ","
        + config.lib.stylix.colors.base00-rgb-b
        + ","
        + ''          0.55);
                    border-radius: 10px;
                    color: #''
        + config.lib.stylix.colors.base07
        + ''          ;
                    transition-property: background-color;
                    transition-duration: .2s;
                }

                tooltip {
                  color: #''
        + config.lib.stylix.colors.base07
        + ''          ;
                  background-color: rgba(''
        + config.lib.stylix.colors.base00-rgb-r
        + ","
        + config.lib.stylix.colors.base00-rgb-g
        + ","
        + config.lib.stylix.colors.base00-rgb-b
        + ","
        + ''          0.9);
                  border-style: solid;
                  border-width: 3px;
                  border-radius: 8px;
                  border-color: #''
        + config.lib.stylix.colors.base08
        + ''          ;
                }

                tooltip * {
                  color: #''
        + config.lib.stylix.colors.base07
        + ''          ;
                  background-color: rgba(''
        + config.lib.stylix.colors.base00-rgb-r
        + ","
        + config.lib.stylix.colors.base00-rgb-g
        + ","
        + config.lib.stylix.colors.base00-rgb-b
        + ","
        + ''          0.0);
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
                    color: #''
        + config.lib.stylix.colors.base0D
        + ''          ;
                }

                /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
                button:hover {
                    background: inherit;
                }

                #workspaces button {
                    padding: 0px 6px;
                    background-color: transparent;
                    color: #''
        + config.lib.stylix.colors.base04
        + ''          ;
                }

                #workspaces button:hover {
                    color: #''
        + config.lib.stylix.colors.base07
        + ''          ;
                }

                #workspaces button.active {
                    color: #''
        + config.lib.stylix.colors.base08
        + ''          ;
                }

                #workspaces button.focused {
                    color: #''
        + config.lib.stylix.colors.base0A
        + ''          ;
                }

                #workspaces button.visible {
                    color: #''
        + config.lib.stylix.colors.base05
        + ''          ;
                }

                #workspaces button.urgent {
                    color: #''
        + config.lib.stylix.colors.base09
        + ''          ;
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
                    color: #''
        + config.lib.stylix.colors.base07
        + ''          ;
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
                    color: #''
        + config.lib.stylix.colors.base04
        + ''          ;
                }

                #custom-hyprprofileicon:hover,
                #custom-quit:hover,
                #custom-lock:hover,
                #custom-reboot:hover,
                #custom-power:hover,
                #idle_inhibitor:hover {
                    color: #''
        + config.lib.stylix.colors.base07
        + ''          ;
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
                    color: #''
        + config.lib.stylix.colors.base0D
        + ''          ;
                }

                #battery {
                    color: #''
        + config.lib.stylix.colors.base0B
        + ''          ;
                }

                #battery.charging, #battery.plugged {
                    color: #''
        + config.lib.stylix.colors.base0C
        + ''          ;
                }

                @keyframes blink {
                    to {
                        background-color: #''
        + config.lib.stylix.colors.base07
        + ''          ;
                        color: #''
        + config.lib.stylix.colors.base00
        + ''          ;
                    }
                }

                #battery.critical:not(.charging) {
                    background-color: #''
        + config.lib.stylix.colors.base08
        + ''          ;
                    color: #''
        + config.lib.stylix.colors.base07
        + ''          ;
                    animation-name: blink;
                    animation-duration: 0.5s;
                    animation-timing-function: linear;
                    animation-iteration-count: infinite;
                    animation-direction: alternate;
                }

                label:focus {
                    background-color: #''
        + config.lib.stylix.colors.base00
        + ''          ;
                }

                #cpu {
                    color: #''
        + config.lib.stylix.colors.base0D
        + ''          ;
                }

                #memory {
                    color: #''
        + config.lib.stylix.colors.base0E
        + ''          ;
                }

                #disk {
                    color: #''
        + config.lib.stylix.colors.base0F
        + ''          ;
                }

                #backlight {
                    color: #''
        + config.lib.stylix.colors.base0A
        + ''          ;
                }

                #temperature {
                  color: #''
        + config.lib.stylix.colors.base08
        + ''
          }

          label.numlock {
              color: #''
        + config.lib.stylix.colors.base04
        + ''          ;
                }

                label.numlock.locked {
                    color: #''
        + config.lib.stylix.colors.base0F
        + ''          ;
                }

                #pulseaudio {
                    color: #''
        + config.lib.stylix.colors.base0C
        + ''          ;
                }

                #pulseaudio.muted {
                    color: #''
        + config.lib.stylix.colors.base04
        + ''          ;
                }

                #tray > .passive {
                    -gtk-icon-effect: dim;
                }

                #tray > .needs-attention {
                    -gtk-icon-effect: highlight;
                }

                #idle_inhibitor {
                    color: #''
        + config.lib.stylix.colors.base04
        + ''          ;
                }

                #idle_inhibitor.activated {
                    color: #''
        + config.lib.stylix.colors.base0F
        + ''          ;
                }
        '';
    };

    home.packages = with pkgs; [
      pwvucontrol
    ];

    wayland.windowManager.hyprland.settings = {
      "$pwvucontrol" = "class:^(com.saivert.pwvucontrol)$";
      exec-once = [
        "waybar"
      ];
      layerrule = [
        "blur,waybar"
        "xray,waybar"
        "blur,gtk-layer-shell"
        "xray,gtk-layer-shell"
      ];
      blurls = [
        "waybar"
        "gtk-layer-shell"
      ];
      windowrulev2 = [
        "opacity 0.80,$pwvucontrol"
        "$scratchpadsize,$pwvucontrol"
      ];
    };
  };
}
