{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.steam;
  jupiter-dock-updater = pkgs.writeTextFile {
    name = "jupiter-dock-updater";
    text = ''
      return 0
    '';
    executable = true;
    destination = "/bin/steamos-polkit-helpers/jupiter-dock-updater";
  };
  steamos-select-branch = pkgs.writeShellScriptBin "steamos-select-branch" ''
    #!/bin/sh
    >&2 echo "stub called with: $*"
    case "$1" in
        "-c")
            # What is our current branch? Pretend to be main
            echo "main"
            ;;
        "-l")
            # What branches are available? Pretend to only have main
            echo "main"
            ;;
        *)
            # Switch branch, just do nothing
            ;;
    esac
  '';
in {
  options.strixos.programs.steam = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable steam
      '';
    };
    withMangohud = mkOption {
      type = types.bool;
      default = true;
      description = ''
        add mangohud to steam path
      '';
    };
    deckyLoader = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          add decky loader to the big picture interface
        '';
      };
      user = mkOption {
        type = types.str;
        default = "decky";
        description = ''
          user that runs decky loader
        '';
      };
      userHome = mkOption {
        type = types.path;
        default = "/var/lib/decky-loader";
        description = ''
          home directory for the decky user
        '';
      };
    };
    gamescopeSession = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable gamescope session for steam;
        '';
      };
      steamos-session-select = mkOption {
        type = types.package;
        default = pkgs.writeShellScriptBin "steamos-session-select" ''
          #!${pkgs.bash}/bin/bash
          steam -shutdown
        '';
        description = ''
          the script that launches when the switch to desktop button is pressed
        '';
      };
      extraEnv = mkOption {
        type = types.attrs;
        default = {};
        description = ''
          extra env to add to gamescope
        '';
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      programs.steam = {
        enable = true;
        protontricks.enable = true;
        extraPackages = lib.lists.optionals cfg.withMangohud [pkgs.mangohud];
      };
    }
    (mkIf cfg.deckyLoader.enable {
      users.users.decky = {
        group = cfg.deckyLoader.user;
        home = cfg.deckyLoader.userHome;
        isSystemUser = true;
      };
      users.groups.decky = {};

      systemd.services.decky-loader = {
        description = "Steam Deck Plugin Loader";

        wantedBy = ["multi-user.target"];
        after = ["network.target"];

        environment = {
          UNPRIVILEGED_USER = cfg.deckyLoader.user;
          UNPRIVILEGED_PATH = cfg.deckyLoader.userHome;
          PLUGIN_PATH = cfg.deckyLoader.userHome + "/plugins";
        };

        path = with pkgs; [];

        preStart = ''
          mkdir -p "${cfg.deckyLoader.userHome}"
          chown -R "${cfg.deckyLoader.user}:" "${cfg.deckyLoader.userHome}"
        '';

        serviceConfig = {
          ExecStart = "${pkgs.decky-loader}/bin/decky-loader";
          KillMode = "process";
          TimeoutStopSec = 45;
        };
      };
    })
    (mkIf cfg.gamescopeSession.enable {
      programs.steam = {
        extraPackages = [
          jupiter-dock-updater
          steamos-select-branch
          cfg.gamescopeSession.steamos-session-select
        ];
        gamescopeSession = {
          enable = true;
          env =
            {
              # mangohud
              STEAM_MANGOAPP_PRESETS_SUPPORTED = "1";
              STEAM_USE_MANGOAPP = "1";
              STEAM_USE_DYNAMIC_VRS = "1";
              STEAM_MANGOAPP_HORIZONTAL_SUPPORTED = "1";
              STEAM_DISABLE_MANGOAPP_ATOM_WORKAROUND = "1";

              # misc
              STEAM_ENABLE_VOLUME_HANDLER = "1";
              STEAM_DISABLE_AUDIO_DEVICE_SWITCHING = "1";
              STEAM_GAMESCOPE_FANCY_SCALING_SUPPORT = "1";
              SRT_URLOPEN_PREFER_STEAM = "1";

              STEAM_GAMESCOPE_NIS_SUPPORTED = "1";

              QT_IM_MODULE = "steam";
              GTK_IM_MODULE = "Steam";
            }
            // cfg.gamescopeSession.extraEnv;
          args = [
            "--mangoapp"
          ];
          steamArgs = [
            "-steamos3"
            "-steampal"
            "-steamdeck"
            "-gamepadui"
            #"-tenfoot"
            "-pipewire-dmabuf"
          ];
        };
      };
    })
  ]);
}
