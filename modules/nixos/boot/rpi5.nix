{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) types mkOption mkIf;
  cfg = config.strixos.boot;
in {
  options.strixos.boot = {
    rpiConfig = mkOption {
      type = types.lines;
      default = '''';
      description = ''
        the extra config added to rpiConfig
      '';
    };
    rpiParamsPre = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        the extra kernel params added before rootwait
      '';
    };
    rpiParamsPost = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        the extra kernel params added after rootwait
      '';
    };
  };
  config = mkIf (cfg.loader == "rpi5") {
    boot = {
      loader = {
        grub.enable = false;
        initScript.enable = true;
      };
      initrd = {
        availableKernelModules = [
          "usbhid"
          "usb_storage"
        ];
      };
      kernelParams =
        cfg.rpiParamsPre
        ++ [
          "console=tty1"
          "rootwait"
        ]
        ++ cfg.rpiParamsPost;
    };
    system.activationScripts.populateFirmware = {
      text = let
        inherit (pkgs) bash lib writeText writeTextFile raspberrypifw;
        configTxt =
          writeText "config.txt" ''
            [all]
            arm_64bit=1
            disable_overscan=1
            initramfs initrd followkernel
            kernel=kernel8.img
          ''
          + cfg.rpiConfig;
        kernelParams = writeTextFile {
          name = "cmdline.txt";
          text = lib.strings.concatStringsSep " " config.boot.kernelParams;
        };
        kernel = "${config.system.build.kernel}/${config.system.boot.loader.kernelFile}";
        initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
      in ''
        echo "Populating /boot firmware files..."

        mkdir -p /boot
        cp ${configTxt} /boot/config.txt
        cp "${kernel}" /boot/kernel8.img
        cp "${initrd}" /boot/initrd
        cp "${kernelParams}" /boot/cmdline.txt

        cp -r ${raspberrypifw}/share/raspberrypi/boot/{start*.elf,*.dtb,bootcode.bin,fixup*.dat,overlays} /boot
      '';
      deps = ["boot"];
    };
  };
}
