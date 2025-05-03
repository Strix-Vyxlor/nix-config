{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.strixos.xdg;
in {
  options.strixos.xdg = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        manage xdg directories
      '';
    };
    userDirs = mkOption {
      type = types.bool;
      default = false;
      description = ''
        set custom userdirs (preset with no desktop)
      '';
    };
    mime = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable mime and mimeApps
      '';
    };
  };

  config = mkIf cfg.enable {
    xdg = {
      enable = true;
      userDirs = {
        enable = cfg.userDirs;
        createDirectories = true;
        music = "${config.home.homeDirectory}/Media/Music";
        videos = "${config.home.homeDirectory}/Media/Videos";
        pictures = "${config.home.homeDirectory}/Media/Pictures";
        templates = "${config.home.homeDirectory}/Templates";
        download = "${config.home.homeDirectory}/Downloads";
        documents = "${config.home.homeDirectory}/Documents";
        desktop = null;
        publicShare = null;
      };
      mime.enable = cfg.mime;
      mimeApps.enable = cfg.mime;
    };
  };
}
