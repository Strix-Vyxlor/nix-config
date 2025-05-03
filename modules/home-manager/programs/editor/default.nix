{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.editor;
  shell = config.lib.strixos.shell.command;
in {
  options.strixos.programs.editor = {
    neovim = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable neovim (strixvim)
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.neovim {
      strixvim = {
        enable = true;
        env = {
          inherit shell;
        };
      };
    })
  ];
}
