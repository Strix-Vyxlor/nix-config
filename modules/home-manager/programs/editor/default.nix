inputs: {
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs.editor;
  shell = config.lib.strixos.shell.command;
in {
  imports = [
    inputs.strixvim.homeManagerModules.strixvim
  ];

  options.strixos.programs.editor = {
    strixvim = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable strixvim (neovim)
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.strixvim {
      programs.strixvim = {
        enable = true;
        env = {
          inherit shell;
        };
      };
      stylix.targets.yazi.enable = true;
      home.sessionVariables = {
        EDITOR = "svim";
      };
    })
    (mkIf (config.lib.strixos.termFileManager != null) {
      programs.strixvim.env.fileManager = config.lib.strixos.termFileManager;
    })
  ];
}
