{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.desktop.hyprland;
in {
  options.strixos.desktop.hyprland.plugins = {
    hyprexpo = mkOption {
      type = types.bool;
      default = false;
      description = ''
        use hyprexpo
      '';
    };
  };
  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.plugins.hyprexpo {
      wayland.windowManager.hyprland = {
        plugins = with pkgs.hyprlandPlugins; [
          hyprexpo
        ];
        settings.plugin = {
          hyprexpo = {
            columns = 3;
            gap_size = 5;
            bg_col = "rgb(${config.lib.stylix.colors.base00})";
            workspace_method = "center current"; # [center/first] [workspace] e.g. first 1 or center m+1

            enable_gesture = true; # laptop touchpad
            gesture_fingers = 3; # 3 or 4
            gesture_distance = 150; # how far is the "max"
            gesture_positive = true; # positive = swipe down. Negative = swipe up.
          };
        };
      };
    })
  ]);
}
