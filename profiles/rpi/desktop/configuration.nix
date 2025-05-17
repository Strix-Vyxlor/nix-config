{
  pkgs,
  lib,
  branch,
  ...
}: {
  imports = [
    ../../system/hardware-configuration.nix
  ];
  strixos = {
    inherit branch;
    hostName = "pix";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
    };
    boot = {
      loader = "rpi5";
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
      superuser = "doas";
      git = true;
      retroarch = {
        enable = true;
        withCores = cores:
          with cores; [
            dolphin
            picodrive
            genesis-plus-gx
          ];
        gamescopeSession = {
          enable = true;
        };
      };
      desktop = {
        hyprland = {
          enable = true;
          xkb = {
            layout = "be";
            variant = "";
            options = "";
          };
          nautilus = true;
          keyring = "gnome-keyring";
          hyprlock = false;
        };
        displayManager = {
          displayManager = "regreet";
          regreet.extraHyprlandConfig = ''
            input {
              touchpad {
                disable_while_typing=false
                natural_scroll=yes
              }
              accel_profile=linear
              kb_layout=be
              numlock_by_default=true
              repeat_delay=350
              repeat_rate=50
            }
          '';
        };
      };
    };
    services = {
      timesync = "chrony";
      ssh.enable = true;
    };
    style.theme.themeDir = ../../../themes/nord;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    helix
    wget
    git
    home-manager
  ];

  system.stateVersion = "25.05";
}
