{
  pkgs,
  lib,
  config,
  branch,
  nixpkgs,
  ...
}: {
  imports = [
    "${nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
  ];
  users.users.root.initialPassword = "root";
  boot = {
    loader = {
      grub.enable = false;
      initScript.enable = true;
    };
    supportedFilesystems = [
      "btrfs"
      "cifs"
      "f2fs"
      "ntfs"
      "vfat"
      "xfs"
    ];
    kernelParams = ["console=tty1" "init=/sbin/init"];
    initrd = {
      availableKernelModules = [
        "usbhid"
        "usbhid"
        "usb_storage"
      ];
    };
  };

  strixos = {
    inherit branch;
    hostName = "strixpi";
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
      kernel = "rpi5";
    };
    programs.git = true;
    services.ssh.enable = true;
    style.targets.enable = false;
  };

  sdImage = {
    populateFirmwareCommands = let
      configTxt = pkgs.writeText "config.txt" ''
        [all]
        arm_64bit=1
        disable_overscan=1
        ramdisk=initrd
        kernel=kernel8.img
      '';
      kernel-params = pkgs.writeTextFile {
        name = "cmdline.txt";
        text = ''
          ${lib.strings.concatStringsSep " " config.boot.kernelParams}
        '';
      };
      kernel = "${config.system.build.kernel}/${config.system.boot.loader.kernelFile}";
      initrd = "${config.system.build.initialRamdisk}/${config.system.boot.loader.initrdFile}";
    in ''
      cp ${configTxt} firmware/config.txt
      cp "${kernel}" firmware/kernel8.img
      cp "${initrd}" firmware/initrd
      cp "${kernel-params}" firmware/cmdline.txt
      cp -r ${pkgs.raspberrypifw}/share/raspberrypi/boot/{start*.elf,*.dtb,bootcode.bin,fixup*.dat,overlays} firmware
    '';
    populateRootCommands = ''
      mkdir -p ./files/sbin
      content="$(
        echo "#!${pkgs.bash}/bin/bash"
        echo "exec ${config.system.build.toplevel}/init"
      )"
      echo "$content" > ./files/sbin/init
      chmod 744 ./files/sbin/init
    '';
  };

  environment.systemPackages = with pkgs; [
    helix
    curl
    zip
    unzip
    ccrypt
    cryptsetup
    parted
    usbutils
    pciutils
    sdparm
    hdparm
    nvme-cli
  ];

  system.stateVersion = "25.05";
}
