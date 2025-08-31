{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.emulationstation;
  userCfg = config.strixos.user;

  es-de-gamescope = let
    exports = builtins.attrValues (
      builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.gamescopeSession.env
    );
  in
    pkgs.writeShellScriptBin "es-de-gamescope" ''
      if [ ! -d ${cfg.homeDir}/ROMs ]; then
        es-de --home ${cfg.homeDir} --create-system-dirs
      fi

      ${builtins.concatStringsSep "\n" exports}
      gamescope ${builtins.toString cfg.gamescopeSession.args} -- es-de --home ${cfg.homeDir} ${builtins.toString cfg.gamescopeSession.emulationstationArgs}
    '';

  gamescopeSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/es-de.desktop" ''
      [Desktop Entry]
      Name=EmulationStation
      Comment=ui for your retro gaming needs
      Exec=${es-de-gamescope}/bin/es-de-gamescope
      Type=Application
    '').overrideAttrs
    (_: {
      passthru.providedSessions = ["es-de"];
    });
in {
  options.strixos.programs.emulationstation = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable EmulationStation
      '';
    };

    homeDir = mkOption {
      type = types.path;
      default = "/home/${userCfg.username}";
      description = ''
        home location of emulationstation
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.emulationstation-de;
      description = ''
        the package to use
      '';
    };

    gamescopeSession = lib.mkOption {
      description = "Run a GameScope driven EmulationStation session from your display-manager";
      default = {};
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "GameScope Session";
          args = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              Arguments to be passed to GameScope for the session.
            '';
          };

          env = mkOption {
            type = types.attrsOf types.str;
            default = {};
            description = ''
              Environmental variables to be passed to GameScope for the session.
            '';
          };

          emulationstationArgs = mkOption {
            type = types.listOf types.str;
            default = [
            ];
            description = ''
              Arguments to be passed to EmulationStation for the session.
            '';
          };
        };
      };
    };

    config = mkIf cfg.enable (mkMerge [
      {
        environment.systemPackages = [cfg.package];
        strixos.programs.retroarch.enable = true;
      }
      (mkIf cfg.gamescopeSession.enable {
        programs.gamescope.enable = lib.mkDefault true;
        services.displayManager.sessionPackages = [
          gamescopeSessionFile
        ];
      })
    ]);
  };
}
