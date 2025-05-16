{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.programs;
  userCfg = config.strixos.user;
in {
  imports = [
    ./nix.nix
    ./retroarch.nix
  ];

  options.strixos.programs = {
    gpg = mkOption {
      type = types.bool;
      default = true;
      description = ''
        enable gnu privacy guard (recomended)
      '';
    };
    superuser = mkOption {
      type = types.nullOr (types.enum [
        "sudo"
        "doas"
      ]);
      default = null;
      description = ''
        command to get superuser priviliges;
        when sudo is not selected whill write schellScript redirecting sudo
      '';
    };
    git = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable git, fixes isue with ownership
        (may be security problem, but i dont realy care)
      '';
    };
  };

  config = mkMerge [
    {
      programs = {
        gnupg.agent = {
          enable = cfg.gpg;
          enableSSHSupport = config.strixos.services.ssh.enable;
        };
        git = {
          enable = cfg.git;
          config.safe.directory = "*";
        };
      };
    }
    (mkIf (cfg.superuser == "sudo") {
      security.sudo = {
        enable = true;
      };
    })
    (mkIf (cfg.superuser == "doas") {
      security.sudo.enable = false;
      security.doas = {
        enable = true;
        extraRules = [
          {
            keepEnv = true;
            persist = true;
          }
        ];
      };

      environment.systemPackages = [
        (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
      ];
    })
    (mkIf (cfg.superuser != null && userCfg.username != null) {
      users.users.${userCfg.username}.extraGroups = ["wheel"];
    })
  ];
}
