{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.desktop.displayManager;

  hyprlandConfig = pkgs.writeText "hyprland-regreet" (''
      exec-once = ${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit
      misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          disable_hyprland_qtutils_check = true
      }

    ''
    + cfg.regreet.extraHyprlandConfig);
in {
  options.strixos.desktop.displayManager.regreet = {
    compositor = mkOption {
      type = types.enum [
        "hyprland"
      ];
      default = "hyprland";
      description = ''
        compositor to run regreet in
      '';
    };
    extraHyprlandConfig = mkOption {
      type = types.lines;
      default = '''';
      description = ''
        extra configuration to add to hyprland for regreet
      '';
    };
  };

  config = mkIf (cfg.displayManager == "regreet") (mkMerge [
    (mkIf (cfg.regreet.compositor == "hyprland") {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprlandConfig}";
            user = config.strixos.user.username;
          };
        };
      };

      programs.regreet = {
        enable = true;
        settings = {
          widget.clock = {
            timezone = config.strixos.locale.timezone;
            format = "%I:%M:%S %p";
          };
        };
      };

      stylix.targets.regreet.enable = true;
    })
  ]);
}
