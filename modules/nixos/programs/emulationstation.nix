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
      gamescope ${builtins.toString cfg.gamescopeSession.args} -- es-de --home ${cfg.homeDir} ${builtins.toString cfg.gamescopeSession.retroarchArgs}
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

  es-de-cage = let
    exports = builtins.attrValues (
      builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.cageSession.env
    );
  in
    pkgs.writeShellScriptBin "es-de-cage" ''
      if [ ! -d ${cfg.homeDir}/ROMs ]; then
        es-de --home ${cfg.homeDir} --create-system-dirs
      fi

      ${builtins.concatStringsSep "\n" exports}
      ${pkgs.cage}/bin/cage ${builtins.toString cfg.cageSession.args} -- es-de --home ${cfg.homeDir} ${builtins.toString cfg.cageSession.retroarchArgs}
    '';

  cageSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/es-de-cage.desktop" ''
      [Desktop Entry]
      Name=EmulationStation (Cage)
      Comment=ui for your retro gaming needs
      Exec=${es-de-cage}/bin/es-de-cage
      Type=Application
    '').overrideAttrs
    (_: {
      passthru.providedSessions = ["es-de-cage"];
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

    cageSession = lib.mkOption {
      description = "Run EmulationStation in Cage";
      default = {};
      type = lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "Cage Session";
          args = mkOption {
            type = types.listOf types.str;
            default = [
              "-s"
              "-m"
              "last"
            ];
            description = ''
              Arguments to be passed to cage for the session.
            '';
          };

          env = mkOption {
            type = types.attrsOf types.str;
            default = {};
            description = ''
              Environmental variables to be passed to cage for the session.
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
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [pkgs.emulationstation-de];
      strixos.programs.retroarch.enable = true;
    }
    (mkIf cfg.gamescopeSession.enable {
      programs.gamescope.enable = lib.mkDefault true;
      services.displayManager.sessionPackages = [
        gamescopeSessionFile
      ];
    })
    (mkIf cfg.cageSession.enable {
      services.displayManager.sessionPackages = [
        cageSessionFile
      ];
    })
  ]);
}
