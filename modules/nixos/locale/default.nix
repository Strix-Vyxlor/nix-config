{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types optional;
  cfg = config.strixos.locale;
in {
  options.strixos.locale = {
    timezone = mkOption {
      type = types.nullOr (types.str);
      default = null;
      description = ''
        timezone to use
      '';
    };
    locale = mkOption {
      type = types.str;
      default = "en_US.UTF-8";
      description = ''
        the system locale
      '';
    };
    consoleKeymap = mkOption {
      type = types.str;
      default = "us";
      description = ''
        linux terminal keymap
      '';
    };
  };

  config = {
    time.timeZone = cfg.timezone;

    i18n = {
      defaultLocale = cfg.locale;
      extraLocaleSettings = {
        LC_ADDRESS = cfg.locale;
        LC_IDENTIFICATION = cfg.locale;
        LC_MEASUREMENT = cfg.locale;
        LC_MONETARY = cfg.locale;
        LC_NAME = cfg.locale;
        LC_NUMERIC = cfg.locale;
        LC_PAPER = cfg.locale;
        LC_TELEPHONE = cfg.locale;
        LC_TIME = cfg.locale;
      };
    };

    console.keyMap = cfg.consoleKeymap;
  };
}
