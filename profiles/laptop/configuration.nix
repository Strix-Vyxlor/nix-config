{
  pkgs,
  lib,
  branch,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  environment.variables.AMD_VULKAN_ICD = "RADV";

  strixos = {
    inherit branch;
    hostName = "nixos";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      extraGroups = ["input" "adbusers" "dialout"];
    };
    style = {
      theme.generateWithImage = ../../themes/background/room_gaming/stil.png;
      desktop = true;
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
      androidCompat = true;
    };
    programs = {
      superuser = "sudo";
      git = true;
      retroarch = {
        enable = true;
        gamescopeSession = {
          enable = true;
        };
      };
      steam = {
        enable = true;
        deckyLoader.enable = true;
        gamescopeSession = {
          enable = true;
          extraEnv = {
            XKB_DEFAULT_LAYOUT = "be";
          };
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
          env=HYPRCURSOR_THEME,rose-pine-hyprcursor
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
  };

  services.ollama = {
    enable = true;
    acceleration = "rocm";
  };

  programs.mosh.enable = true;

  nixpkgs.config.allowUnfree = true;

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  environment.systemPackages = with pkgs; [
    helix
    rose-pine-hyprcursor
    wget
    git
    home-manager
  ];

  system.stateVersion = "25.05";
}
