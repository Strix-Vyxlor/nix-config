{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.browser.brave;
in {
  options.strixos.programs.browser.brave = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable brave browser
      '';
    };
    makeDefault = mkOption {
      type = types.bool;
      default = false;
      description = ''
        make brave default
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [pkgs.brave];
    }
    (mkIf cfg.makeDefault {
      xdg.mimeApps.defaultApplications = {
        "text/html" = "brave-browser.desktop";
        "x-scheme-handler/http" = "brave-browser.desktop";
        "x-scheme-handler/https" = "brave-browser.desktop";
        "x-scheme-handler/about" = "brave-browser.desktop";
        "x-scheme-handler/unknown" = "brave-browser.desktop";
      };

      home.sessionVariables = {
        DEFAULT_BROWSER = "${pkgs.brave}/bin/brave";
      };
    })
  ]);
}
