{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  strixos = {
    hostName = "nixos";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      extraGroups = ["input" "adbusers" "dialout"];
    };
    style = {
      theme.generateWithImage = ../../themes/background/cyber_city.jpg;
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
        decky-loader.enable = true;
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

  boot.kernelParams = ["resume=UUID=3803af9e-60f0-48cc-b626-9602e774eba7" "mem_sleep_default=deep"];
  powerManagement.enable = true;
  hardware.amdgpu.opencl.enable = true;
  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend";
  };

  networking.hosts = {"100.70.241.44" = ["pihole.strix"];};
  networking.nameservers = [
    "192.168.124.152"
    "100.70.241.44"
  ];

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=1800
    SuspendState=mem
  '';

  environment.variables.AMD_VULKAN_ICD = "RADV";
  virtualisation.waydroid.enable = true;
  virtualisation.waydroid.package = pkgs.waydroid-nftables;
  networking.nftables.enable = true;

  services.upower.enable = true;
  programs.mosh.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["mbedtls-2.28.10"];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  # nix.buildMachines = [
  #   {
  #     hostName = "strix-server";
  #     systems = ["x86_64-linux" "aarch64-linux" "riscv64-linux"];
  #     protocol = "ssh";
  #     sshUser = "root";
  #     maxJobs = 2;
  #     speedFactor = 2;
  #     supportedFeatures = ["benchmark" "big-parallel" "kvm" "nixos-test"];
  #     mandatoryFeatures = [];
  #   }
  #   {
  #     hostName = "strix-desktop-builder";
  #     systems = ["x86_64-linux" "aarch64-linux" "riscv64-linux"];
  #     protocol = "ssh";
  #     sshUser = "root";
  #     maxJobs = 2;
  #     speedFactor = 1;
  #     supportedFeatures = ["benchmark" "big-parallel" "kvm" "nixos-test"];
  #     mandatoryFeatures = [];
  #   }
  # ];
  #
  # nix.distributedBuilds = true;

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
  };

  environment.systemPackages = with pkgs; [
    helix
    rose-pine-hyprcursor
    wget
    git
    home-manager
    wl-clipboard
    waydroid-nftables
    alsa-utils
  ];

  system.stateVersion = "25.11";
}
