{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.shell;
in {
  imports = [
    ./nushell.nix
    ./integrations.nix
    ./prompt.nix
  ];

  options.strixos.shell = {
    defaultShell = mkOption {
      type = types.nullOr (types.enum [
        "bash"
        "nushell"
      ]);
      default = "bash";
      description = ''
        the default shell (not actualy default, that's bash)
      '';
    };
  };

  config = mkMerge [
    {
      home.shell.enableShellIntegration = false;
      programs.bash = {
        enable = true;
        enableCompletion = true;
        shellAliases = {
          ll = "ls -l";
          lla = "ls -la";
        };
        bashrcExtra = ''
          PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
          PS1='\[\e[31m\]\u\[\e[0m\]@\[\e[31m\]\h\[\e[33m\] (''${PS1_CMD1})\[\e[0m\]>\[\e[97m\] \[\e[37m\]\w\n\[\e[33m\]$?\[\e[36;1m\]>\[\e[0;97m\] \[\e[0m\]'
        '';
      };
    }
    (mkIf (cfg.defaultShell == "bash") {
      lib.strixos.shell.package = pkgs.bash;
      lib.strixos.shell.command = "bash";
    })
    (mkIf (cfg.defaultShell == "nushell") {
      lib.strixos.shell.package = pkgs.nushell;
      lib.strixos.shell.command = "nu";
    })
  ];
}
