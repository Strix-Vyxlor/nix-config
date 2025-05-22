{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.browser.floorp;
in {
  options.strixos.programs.browser.floorp = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable floorp browser
      '';
    };
    makeDefault = mkOption {
      type = types.bool;
      default = false;
      description = ''
        make floorp default
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home.packages = [pkgs.floorp];
    }
    (mkIf cfg.makeDefault {
      xdg.mimeApps = {
        defaultApplications = {
          "text/html" = "floorp.desktop";
          "x-scheme-handler/about" = "floorp.desktop";
          "x-scheme-handler/http" = "floorp.desktop";
          "x-scheme-handler/https" = "floorp.desktop";
          "x-scheme-handler/unknown" = "floorp.desktop";
          "x-scheme-handler/chrome" = "floorp.desktop";
          "application/x-extension-htm" = "floorp.desktop";
          "application/x-extension-html" = "floorp.desktop";
          "application/x-extension-shtml" = "floorp.desktop";
          "application/xhtml+xml" = "floorp.desktop";
          "application/x-extension-xhtml" = "floorp.desktop";
          "application/x-extension-xht" = "floorp.desktop";
        };
        associations.added = {
          "x-scheme-handler/http" = "floorp.desktop";
          "x-scheme-handler/https" = "floorp.desktop";
          "x-scheme-handler/chrome" = "floorp.desktop";
          "text/html" = "floorp.desktop";
          "application/x-extension-htm" = "floorp.desktop";
          "application/x-extension-html" = "floorp.desktop";
          "application/x-extension-shtml" = "floorp.desktop";
          "application/xhtml+xml" = "floorp.desktop";
          "application/x-extension-xhtml" = "floorp.desktop";
          "application/x-extension-xht" = "floorp.desktop";
        };
      };

      lib.strixos.defaultBrowser = "${pkgs.floorp}/bin/floorp";
    })
  ]);
}
