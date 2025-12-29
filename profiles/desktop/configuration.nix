{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  strixos = {
    hostName = "strix-desktop";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      extraGroups = ["input" "adbusers" "dialout"];
    };
    style = {
      theme.generateWithImage = ../../themes/background/orange_city/stil.png;
      desktop = true;
    };
    boot = {
      loader = null;
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
      kernel = "latest";
      graphics = true;
      bluetooth = true;
    };
    programs = {
      superuser = "sudo";
      git = true;
      retroarch = {
        enable = true;
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

  boot.loader = {
    systemd-boot.enable = false;
    efi.canTouchEfiVariables = true;
    grub = {
      enable = true;
      devices = ["nodev"];
      efiSupport = true;
      useOSProber = true;
    };
  };

  hardware.amdgpu.opencl.enable = true;

  services.hardware.openrgb = {
    startupProfile = "default";
    enable = true;
    motherboard = "amd";
    package =
      pkgs.openrgb-with-all-plugins;
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [hid-tmff2];

  networking.hosts = {"100.70.241.44" = ["pihole.strix"];};
  networking.nameservers = [
    "192.168.124.152"
    "100.70.241.44"
  ];

  programs.mosh.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["mbedtls-2.28.10"];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm;
  };

  environment.systemPackages = with pkgs; [
    openrgb-with-all-plugins
    helix
    rose-pine-hyprcursor
    wget
    git
    home-manager
    wl-clipboard
  ];

  system.stateVersion = "25.11";
}
