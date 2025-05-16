{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.services;
in {
  options.strixos.services = {
    timesync = mkOption {
      type = types.nullOr (types.enum [
        "timesyncd"
        "chrony"
        "ntpd"
        "ntpd-rs"
      ]);
      default = null;
      description = ''
        time sync client to use
      '';
    };
    tailscale = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable tailscale
      '';
    };
    ssh = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enable openssh;
        '';
      };
      AllowUsers = mkOption {
        type = types.nullOr (types.listOf types.str);
        default = null;
        description = ''
          users allow to use ssh
        '';
      };
      rootPassword = mkOption {
        type = types.bool;
        default = false;
        description = ''
          allow root login with password
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.timesync == "timesyncd") {
      services.timesyncd.enable = true;
    })
    (mkIf (cfg.timesync == "chrony") {
      services.chrony.enable = true;
    })
    (mkIf (cfg.timesync == "ntpd") {
      services.ntp.enable = true;
    })
    (mkIf (cfg.timesync == "ntpd-rs") {
      services.ntpd-rs.enable = true;
    })
    (let
      enableSSH =
        if (cfg.ssh.enable && !config.strixos.programs.gpg)
        then throw "enable gpg to use ssh"
        else true;
    in {
      services = {
        tailscale.enable = cfg.tailscale;
        openssh = {
          enable = enableSSH;
          settings = {
            inherit (cfg.ssh) AllowUsers;
            PasswordAuthentication = true;
            PermitRootLogin =
              if cfg.ssh.rootPassword
              then "yes"
              else "prohibit-password";
          };
        };
      };
    })
  ];
}
