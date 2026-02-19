{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.strix-shell = {
    style = builtins.readFile (pkgs.runCommandLocal "strix-shell-style" {} ''
      ${pkgs.dart-sass}/bin/sass ${config.programs.matugen.theme.files}/strix-shell.scss $out
    '');
    colors = lib.mkForce null;
    config = {
      BarType = "horizontal";
      HorizontalBar = {
        Widgets = {
          Left = [
            "PopoverPower"
            "HyprlandWorkspace"
          ];
          Center = [
            "Clock"
          ];
          Right = [
            "Tray"
            "Inhibitor"
            "SimpleNetwork"
            "Battery"
          ];
        };
        PopoverPower = {
          label = "";
          buttons = [
            [
              {
                label = "⏻";
                action = "systemctl poweroff";
                class = "ShutdownButton";
              }
              {
                label = "󰑥";
                action = "systemctl reboot";
                class = "RebootButton";
              }
            ]
            [
              {
                label = "󰍃";
                action = "hyprshutdown";
                class = "LogoutButton";
              }
              {
                label = "";
                action = "systemctl hibernate";
                class = "HibernateButton";
              }
            ]
          ];
        };
        HyprlandWorkspace.preload = 5;
        Battery = {
          icons = [
            "󰂎"
            "󰁻"
            "󰁼"
            "󰁾"
            "󰂀"
            "󰂂"
            "󰁹"
          ];
          critical_icon = "󰂃";
          charging_icon = "󰂄";
          low = 25;
          critical = 10;
        };
        Clock = {
          format = "%I:%M:%S %P";
          tooltip = "%a %d %b";
        };
      };
    };
  };
}
