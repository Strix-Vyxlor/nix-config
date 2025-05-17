{
  pkgs,
  lib,
  branch,
  ...
}: let
  es-de-cage = let
    exports = builtins.attrValues (
      builtins.mapAttrs (n: v: "export ${n}=${v}") cfg.cageSession.env
    );
  in
    pkgs.writeShellScriptBin "es-de-cage" ''
      if [ ! -d ${cfg.homeDir}/ROMs ]; then
        es-de --home ${cfg.homeDir} --create-system-dirs
      fi

      ${builtins.concatStringsSep "\n" exports}
      ${pkgs.cage}/bin/cage ${builtins.toString cfg.cageSession.args} -- es-de --home ${cfg.homeDir} ${builtins.toString cfg.cageSession.retroarchArgs}
    '';
in {
  imports = [
    ../../../system/hardware-configuration.nix
  ];
  strixos = {
    inherit branch;
    hostName = "retropi";
    user = {
      username = "Gamer";
    };
    boot = {
      loader = "rpi5";
      rpiConfig = ''
        dtoverlay=vc4-kms-v3d
      '';
      plymouth.enable = true;
    };
    hardware = {
      kernel = "rpi5";
      graphics = true;
      bluetooth = true;
    };
    network = {
      manager = "network-manager";
      avahi = true;
    };
    locale = {
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
      consoleKeymap = "be-latin1";
    };
    programs = {
      superuser = "sudo";
      git = true;
      emulationstation = {
        enable = true;
        cageSession = {
          enable = true;
        };
      };
    };
    services = {
      timesync = "timesyncd";
      ssh.enable = true;
    };
    style.theme.themeDir = ../../../themes/nord;
  };

  zramSwap.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "freeimage-3.18.0-unstable-2024-04-18"
  ];

  services = {
    xserver.xkb = {
      layout = "be";
      variant = "";
      options = "";
    }; # NOTE: may need to enable xserver
    gvfs.enable = true;
    udisks2.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    dbus = {
      enable = true;
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd ${es-de-cage}/bin/es-de-cage";
        user = "gamer";
      };
      initial_session = {
        command = "${es-de-cage}/bin/es-de-cage";
        user = "gamer";
      };
    };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    helix
    wget
    git
    home-manager
  ];

  system.stateVersion = "25.05";
}
