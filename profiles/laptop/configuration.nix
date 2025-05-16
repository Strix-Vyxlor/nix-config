{
  pkgs,
  lib,
  branch,
  ...
}: {
  imports = [
    ../../system/hardware-configuration.nix

    ../../system/games/steam/steam.nix
    ../../system/games/steam/gamescope-session.nix
    ../../system/games/steam/decky-loader.nix
  ];

  strixos = {
    inherit branch;
    hostName = "nixos";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      extraGroups = ["input"];
    };
    boot = {
      loader = "systemd-boot";
      plymouth.enable = true;
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
    hardware = {
      kernel = "testing";
      graphics = true;
      bluetooth = true;
      tlp = true;

      platformioCompat = true;
    };
    programs = {
      superuser = "sudo";
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
    };
    services = {
      timesync = "timesyncd";
      tailscale = true;
      ssh = {
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
      };
      displayManager = {
        displayManager = "regreet";
        regreet.extraHyprlandConfig = ''
          exec-once = swayosd-server
          bind=,XF86AudioMute, exec, swayosd-client --output-volume mute-toggle
          bind=,XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle
          bind=,XF86AudioLowerVolume, exec, swayosd-client --output-volume lower
          bind=,XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise
          bind=,XF86MonBrightnessUp, exec, swayosd-client --brightness raise
          bind=,XF86MonBrightnessDown, exec, swayosd-client --brightness lower
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
          monitor=eDP-1,1920x1200,0x0,1
          monitor=HDMI-A-1,1920x1080,-1920x0,1
        '';
      };
    };
    style.theme.themeDir = ../../themes/nord;
  };

  nixpkgs.config.allowUnfree = true;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  environment.systemPackages = with pkgs; [
    helix
    wget
    git
    home-manager
  ];

  system.stateVersion = "25.05";
}
