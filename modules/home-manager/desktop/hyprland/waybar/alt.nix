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
  config = mkIf (cfg.enable && (cfg.apps.statusbar == "waybar-alt")) {
    programs.waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";

          modules-left = ["group/power" "clock" "tray"];
          modules-center = ["hyprland/workspaces"];
          modules-right =
            [
              "group/expand"
            ]
            ++ lib.lists.optionals waybarCfg.bluetooth ["bluetooth"]
            ++ [
              "network"
            ]
            ++ lib.lists.optionals waybarCfg.battery ["battery"];
          "hyprland/workspaces" = {
            "format" = "{icon}";
            "format-icons" = {
              "active" = "";
              "default" = "";
              "empty" = "";
            };
            "persistent-workspaces" = {
              "*" = [1 2 3 4 5];
            };
          };
          "custom/notification" = {
            "tooltip" = false;
            "format" = "";
            "on-click" = "swaync-client -t -sw";
            "escape" = true;
          };
          "clock" = {
            "format" = "{:%I:%M:%S %p} ";
            "interval" = 1;
            "tooltip-format" = "<tt>{calendar}</tt>";
            "calendar" = {
              "format" = {
                "today" = "<span color='#fAfBfC'><b>{}</b></span>";
              };
            };
            "actions" = {
              "on-click-right" = "shift_down";
              "on-click" = "shift_up";
            };
          };
          "network" = {
            "format-wifi" = "";
            "format-ethernet" = "󰈀";
            "format-disconnected" = "";
            "tooltip-format-disconnected" = "Error";
            "tooltip-format-wifi" = "{essid} ({signalStrength}%) ";
            "tooltip-format-ethernet" = "{ifname}";
          };
          "bluetooth" = {
            "format-on" = "󰂯";
            "format-off" = "BT-off";
            "format-disabled" = "󰂲";
            "format-connected-battery" = "󰂯";
            "format-alt" = "{device_battery_percentage}% 󰂯";
            "tooltip-format" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
            "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
            "tooltip-format-enumerate-connected" = "{device_alias}\n{device_address}";
            "tooltip-format-enumerate-connected-battery" = "{device_alias}\n{device_address}\n{device_battery_percentage}%";
          };
          "battery" = {
            "interval" = 30;
            "states" = {
              "good" = 95;
              "warning" = 30;
              "critical" = 20;
            };
            "format" = "{icon}";
            "format-charging" = "󰂄";
            "format-plugged" = "";
            "format-alt" = "{capacity}% {icon}";
            "format-icons" = [
              "󰁻"
              "󰁼"
              "󰁾"
              "󰂀"
              "󰂂"
              "󰁹"
            ];
          };
          "custom/expand" = {
            "format" = "";
            "tooltip" = false;
          };
          "custom/endpoint" = {
            "format" = "|";
            "tooltip" = false;
          };
          "group/expand" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 600;
              "transition-to-left" = true;
              "click-to-reveal" = true;
            };
            "modules" =
              ["custom/expand" "cpu" "memory" "temperature"]
              ++ lib.lists.optionals waybarCfg.wakeLock ["idle_inhibitor"]
              ++ ["custom/endpoint"];
          };
          "cpu" = {
            "format" = "󰻠";
            "tooltip" = true;
          };
          "memory" = {
            "format" = "";
          };
          "temperature" = {
            "critical-threshold" = 80;
            "format" = "";
          };
          "idle_inhibitor" = {
            "format" = "{icon}";
            "format-icons" = {
              "activated" = "󱙱";
              "deactivated" = "󰌾";
            };
          };
          "tray" = {
            "icon-size" = 14;
            "spacing" = 10;
          };

          "group/power" = {
            "orientation" = "horizontal";
            "drawer" = {
              "transition-duration" = 500;
              "children-class" = "not-power";
              "transition-left-to-right" = false;
            };
            "modules" = [
              "custom/os"
              "custom/power"
              "custom/reboot"
              "custom/quit"
            ];
          };
          "custom/os" = {
            "format" = " {} ";
            "exec" = ''echo "" '';
            "interval" = "once";
            "on-click" = "";
            "tooltip" = false;
          };

          "custom/quit" = {
            "format" = "󰍃";
            "tooltip" = false;
            "on-click" = "hyprctl dispatch exit";
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
        };
      };
      style = with config.lib.stylix.colors; ''

        * {
            font-size:15px;
            font-family: "${styleCfg.desktop.font.monospace.name}";
        }
        window#waybar{
            all:unset;
        }
        .modules-left {
            padding:7px;
            margin: 5px 0px 3px 10px;
            border-radius:10px;
            background: alpha(#${base00},.6);
            box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
        }
        .modules-center {
            padding:7px;
            margin:5px 0px 3px 0px;
            border-radius:10px;
            background: alpha(#${base00},.6);
            box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
        }
        .modules-right {
            padding:7px;
            margin: 5px 10px 3px 0px;
            border-radius:10px;
            background: alpha(#${base00},.6);
            box-shadow: 0px 0px 2px rgba(0, 0, 0, .6);
        }
        tooltip {
            background:#${base00};
            color: #${base04};
        }
        ${
          # #clock:hover, #custom-pacman:hover, #custom-notification:hover,#bluetooth:hover,#network:hover,#battery:hover, #cpu:hover,#memory:hover,#temperature:hover{
          #     transition: all .3s ease;
          #     color:#${base0D};
          # }
          ""
        }
        custom-notification {
            padding: 0px 5px;
            transition: all .3s ease;
            color:#${base04};
        }
        #clock{
            padding: 0px 5px 0px 2px;
            color:#${base04};
            transition: all .3s ease;
        }
        #workspaces {
            padding: 0px 5px;
        }
        #workspaces button {
            all:unset;
            padding: 0px 5px;
            color: alpha(#${base0D},.4);
            transition: all .2s ease;
        }
        #workspaces button:hover {
            color:rgba(0,0,0,0);
            border: none;
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
            transition: all 1s ease;
        }
        #workspaces button.active {
            color: #${base0D};
            border: none;
            text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
        }
        #workspaces button.empty {
            color: rgba(0,0,0,0);
            border: none;
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .2);
        }
        #workspaces button.empty:hover {
            color: rgba(0,0,0,0);
            border: none;
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .5);
            transition: all 1s ease;
        }
        #workspaces button.empty.active {
            color: #${base0D};
            border: none;
            text-shadow: 0px 0px 2px rgba(0, 0, 0, .5);
        }
        #bluetooth{
            padding: 0px 4px 0px 0px;
            transition: all .3s ease;
            color:#${base04};

        }
        #network{
            padding: 0px 9px 0px 1px;
            transition: all .3s ease;
            color:#${base04};

        }
        #battery{
            padding: 0px 5px;
            transition: all .3s ease;
            color:#${base04};
        }
        #battery.charging {
            color: #${base0B};
        }

        #battery.warning:not(.charging) {
            color: #${base09};
        }

        #battery.critical:not(.charging) {
            color: #${base08};
            animation-name: blink;
            animation-duration: 0.5s;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            animation-direction: alternate;
        }
        #group-expand{
            padding: 0px 5px;
            transition: all .3s ease;
        }
        #custom-expand{
            padding: 0px 5px;
            color:alpha(#${base03},.6);
            text-shadow: 0px 0px 2px rgba(0, 0, 0, .7);
            transition: all .3s ease;
        }
        #custom-expand:hover,#custom-quit:hover, #custom-reboot:hover, #custom-power:hover, #idle_inhibitor:hover{
            color:rgba(255,255,255,.2);
            text-shadow: 0px 0px 2px rgba(255, 255, 255, .5);
        }

        #cpu,#memory,#temperature{
            padding: 0px 5px;
            transition: all .3s ease;
            color:#${base04};

        }

        #idle_inhibitor {
          padding: 0px 5px 0px 0px;
          transition: all .3s ease;
          color: #${base04};
        }

        #idle_inhibitor.activated {
          color: #${base0D};
        }

        #custom-endpoint{
            color:alpha(#${base03},.6);
            padding: 0px 5px 0px 0px;
            text-shadow: 0px 0px 1.5px rgba(0, 0, 0, .7);

        }
        #tray{
            padding: 0px 5px;
            transition: all .3s ease;

        }
        #tray menu * {
            padding: 0px 5px;
            transition: all .3s ease;
        }

        #tray menu separator {
            padding: 0px 5px;
            transition: all .3s ease;
        }

        #group-power{
            padding: 0;
            transition: all .3s ease;
        }

        #custom-os {
          padding: 0px;
          margin: 0px;
          color:#${base04};
          transition: all .3s ease;
        }

        #custom-quit, #custom-reboot, #custom-power {
          color:#${base04};
          padding: 0px 3px;
          transition: all .3s ease;

        }
      '';
    };

    wayland.windowManager.hyprland.settings = {
      exec-once = [
        "waybar"
      ];
      layerrule = [
        "blur,waybar"
        "xray,waybar"
        "ignorezero, waybar"
        "ignorealpha 0.5, waybar"
      ];
    };
  };
}
