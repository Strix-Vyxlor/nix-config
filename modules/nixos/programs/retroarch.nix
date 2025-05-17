{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.retroarch;

  retroarchPkg =
    if cfg.withCores == null
    then pkgs.retroarch-full
    else (pkgs.retroarch.withCores cfg.withCores);

  retroarch-gamescope = let
    exports = builtins.attrValues (
      builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.gamescopeSession.env
    );
  in
    pkgs.writeShellScriptBin "retroarch-gamescope" ''
      ${builtins.concatStringsSep "\n" exports}
      gamescope ${builtins.toString cfg.gamescopeSession.args} -- retroarch ${builtins.toString cfg.gamescopeSession.retroarchArgs}
    '';

  gamescopeSessionFile =
    (pkgs.writeTextDir "share/wayland-sessions/retroarch.desktop" ''
      [Desktop Entry]
      Name=Retroarch
      Comment=Frondend for libretro
      Exec=${retroarch-gamescope}/bin/retroarch-gamescope
      Type=Application
    '').overrideAttrs
    (_: {
      passthru.providedSessions = ["retroarch"];
    });
in {
  options.strixos.programs.retroarch = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable retroarch
      '';
    };
    withCores = mkOption {
      type = let
        fromType = types.listOf types.package;
      in
        types.nullOr (types.functionTo fromType);
      default = null;
      description = ''
        cores to include retroarch (else all installed)
      '';
    };

    gamescopeSession = lib.mkOption {
      description = "Run a GameScope driven Steam session from your display-manager";
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

          retroarchArgs = mkOption {
            type = types.listOf types.str;
            default = [
            ];
            description = ''
              Arguments to be passed to Retroarch for the session.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages =
      [retroarchPkg]
      ++ lib.lists.optionals cfg.gamescopeSession.enable [retroarch-gamescope];

    programs.gamescope.enable = lib.mkDefault cfg.gamescopeSession.enable;
    services.displayManager.sessionPackages = lib.mkIf cfg.gamescopeSession.enable [
      gamescopeSessionFile
    ];
  };
}
