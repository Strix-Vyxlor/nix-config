{
  pkgs,
  lib,
  config,
  ...
}: let
  background = ../../themes/background/commingheremoreoftenlatly/jake-comingheremoreoftenlately.jpg;
in {
  imports = [
    ./hardware-configuration.nix
  ];
  programs.matugen = {
    enable = true;
    wallpaper = background;
    source_color = "#a91a16";
    type = "scheme-tonal-spot";
    jsonFormat = "strip";
    variant = "dark";
    lightness_dark = -0.05;
    templates = {
      base16 = {
        input_path = "${./.}/themes/base16.in.yaml";
        output_path = "~/base16.yaml";
      };
    };
  };
  strixos = {
    hostName = "nixos";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      extraGroups = ["input" "adbusers" "dialout"];
    };
    style = {
      theme = {
        scheme = "${config.programs.matugen.theme.files}/base16.yaml";
        polarity = "dark";
        image = background;
      };
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

  boot.loader = {
    limine = {
      enable = true;
      maxGenerations = 10;
      efiSupport = true;
      extraEntries = ''
        /Windows
          protocol: efi
          path: boot():///EFI/Microsoft/Boot/bootmgfw.efi
      '';
      style = {
        wallpapers = [background];
        wallpaperStyle = "centered";
        backdrop = config.programs.matugen.theme.colors.background.default;
        interface = {
          helpHidden = true;
          branding = "StrixOs";
          brandingColor = 2;
        };
        graphicalTerminal = {
          palette =
            config.programs.matugen.theme.colors.background.default
            + ";"
            + config.programs.matugen.theme.colors.error.default
            + ";"
            + config.programs.matugen.theme.colors.primary.default
            + ";"
            + config.programs.matugen.theme.colors.secondary.default
            + ";"
            + config.programs.matugen.theme.colors.tertiary.default
            + ";"
            + config.programs.matugen.theme.colors.primary_container.default
            + ";"
            + config.programs.matugen.theme.colors.secondary_container.default
            + ";"
            + config.programs.matugen.theme.colors.surface_container.default;
          brightPalette =
            config.programs.matugen.theme.colors.background.default
            + ";"
            + config.programs.matugen.theme.colors.error.default
            + ";"
            + config.programs.matugen.theme.colors.primary.default
            + ";"
            + config.programs.matugen.theme.colors.secondary.default
            + ";"
            + config.programs.matugen.theme.colors.tertiary.default
            + ";"
            + config.programs.matugen.theme.colors.primary_container.default
            + ";"
            + config.programs.matugen.theme.colors.secondary_container.default
            + ";"
            + config.programs.matugen.theme.colors.surface_container.default;
          foreground = config.programs.matugen.theme.colors.on_background.default;
          background = "40" + config.programs.matugen.theme.colors.background.default;
          brightForeground = config.programs.matugen.theme.colors.on_surface.default;
          brightBackground = config.programs.matugen.theme.colors.surface_container.default;
          margin = 350;
        };
      };
    };
    systemd-boot.enable = false;
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

  services.upower.enable = true;
  programs.mosh.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = ["mbedtls-2.28.10"];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
    "riscv64-linux"
  ];

  services.fprintd = {
    enable = true;
    tod = {
      enable = true;
      driver = pkgs.pkgs.libfprint-2-tod1-goodix-550a;
    };
  };
  security.pam.services = {
    sudo.fprintAuth = false;
    login.fprintAuth = false;
    greetd.fprintAuth = false;
    su.fprintAuth = false;
    sshd.fprintAuth = false;
    polkit-1.fprintAuth = false;
    other.fprintAuth = false;
    strixdm = {
      name = "strixdm";
      unixAuth = true;
      fprintAuth = false;
    };
    strixdm-fprint = {
      name = "strixdm-fprint";
      unixAuth = false;
      fprintAuth = true;
    };
  };

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
