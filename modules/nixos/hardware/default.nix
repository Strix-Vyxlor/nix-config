{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge optional;
  cfg = config.strixos.hardware;
in {
  options.strixos.hardware = {
    kernel = mkOption {
      type = types.enum [
        "lts"
        "testing"
        "latest"
        "zen"
      ];
      default = "latest";
      description = ''
        the kernel type to use
      '';
    };
    consoleLogLevel = mkOption {
      type = types.int;
      default = 1;
      description = ''
        The kernel console `loglevel`. All Kernel Messages with a log level smaller
        than this setting will be printed to the console.
      '';
    };
    graphics = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable mesa (auto enable 32bit support on x86_64)
      '';
    };
    bluetooth = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable bluetooth driver
      '';
    };
    platformioCompat = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable udev rules for platformio
      '';
    };
    tlp = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable tlp deamon
      '';
    };
  };

  config = mkMerge [
    (mkIf (cfg.kernel == "lts") {
      boot.kernelPackages = pkgs.linuxPackages;
    })
    (mkIf (cfg.kernel == "testing") {
      boot.kernelPackages = pkgs.linuxPackages_testing;
    })
    (mkIf (cfg.kernel == "latest") {
      boot.kernelPackages = pkgs.linuxPackages_latest;
    })
    (mkIf (cfg.kernel == "zen") {
      boot.kernelPackages = pkgs.linuxPackages_zen;
    })
    (mkIf cfg.platformioCompat {
      services.udev.packages = [
        pkgs.platformio-core
        pkgs.openocd
      ];
    })
    (mkIf cfg.bluetooth {
      environment.systemPackages = [pkgs.bluez pkgs.bluez-tools];
    })
    (mkIf (pkgs.system == "x86_64-linux") {
      hardware.graphics.enable32Bit = cfg.graphics;
    })
    {
      boot = {inherit (cfg) consoleLogLevel;};
      hardware = {
        graphics.enable = cfg.graphics;
        bluetooth.enable = cfg.bluetooth;
      };

      services.tlp = {
        enable = cfg.tlp;
        settings = {
          CPU_DRIVER_OPMODE_ON_AC = "active";
          CPU_DRIVER_OPMODE_ON_BAT = "active";

          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_SCALING_GOVERNOR_ON_AC = "performance";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

          CPU_MIN_PERF_ON_AC = 0;
          CPU_MAX_PERF_ON_AC = 100;
          CPU_MIN_PERF_ON_BAT = 0;
          CPU_MAX_PERF_ON_BAT = 100;

          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;

          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 100;

          PLATFORM_PROFILE_ON_AC = "performance";
          PLATFORM_PROFILE_ON_BAT = "balanced";
        };
      };
    }
  ];
}
