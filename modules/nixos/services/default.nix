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
    };
    rtkit = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable realitimekit
      '';
    };
    pipewire = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable pipewire and wireblumper and all submodules (recomends rtkit)
      '';
    };
    dbus = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable dbus and dconf
      '';
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
    {
      services = {
        tailscale.enable = cfg.tailscale;
        openssh = {
          enable = cfg.ssh.enable && config.strixos.programs.gpg;
          settings = {
            inherit (cfg.ssh) AllowUsers;
            PasswordAuthentication = true;
            PermitRootLogin = "prohibit-password";
          };
        };
        pipewire = {
          enable = cfg.pipewire;
          alsa.enable = true;
          pulse.enable = true;
          jack.enable = true;
          alsa.support32Bit = pkgs.system == "x86_64-linux";
        };
        dbus = {
          enable = cfg.dbus;
          packages = [pkgs.dconf];
        };
      };
      security.rtkit.enable = cfg.rtkit;
      programs.dconf.enable = cfg.dbus;
    }
  ];
}
