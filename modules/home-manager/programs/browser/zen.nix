inputs: {
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.browser.zen-browser;
in {
  options.strixos.programs.browser.zen-browser = {
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
      home.packages = [inputs.zen-browser.packages."${pkgs.system}".default];
    }
    (mkIf cfg.makeDefault {
      xdg.mimeApps = {
        defaultApplications = {
          "text/html" = "zen-beta.desktop";
          "x-scheme-handler/about" = "zen-beta.desktop";
          "x-scheme-handler/http" = "zen-beta.desktop";
          "x-scheme-handler/https" = "zen-beta.desktop";
          "x-scheme-handler/unknown" = "zen-beta.desktop";
          "x-scheme-handler/chrome" = "zen-beta.desktop";
          "application/x-extension-htm" = "zen-beta.desktop";
          "application/x-extension-html" = "zen-beta.desktop";
          "application/x-extension-shtml" = "zen-beta.desktop";
          "application/xhtml+xml" = "zen-beta.desktop";
          "application/x-extension-xhtml" = "zen-beta.desktop";
          "application/x-extension-xht" = "zen-beta.desktop";
        };
        associations.added = {
          "x-scheme-handler/http" = "zen-beta.desktop";
          "x-scheme-handler/https" = "zen-beta.desktop";
          "x-scheme-handler/chrome" = "zen-beta.desktop";
          "text/html" = "zen-beta.desktop";
          "application/x-extension-htm" = "zen-beta.desktop";
          "application/x-extension-html" = "zen-beta.desktop";
          "application/x-extension-shtml" = "zen-beta.desktop";
          "application/xhtml+xml" = "zen-beta.desktop";
          "application/x-extension-xhtml" = "zen-beta.desktop";
          "application/x-extension-xht" = "zen-beta.desktop";
        };
      };

      lib.strixos.programs.defaultBrowser = "${inputs.zen-browser.packages."${pkgs.system}".default}/bin/zen";
    })
  ]);
}
