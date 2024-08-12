{ pkgs, ... }:
{
  services.udev = {
    enable = true;
    packages = [ 
      pkgs.platformio-core.udev
      pkgs.openocd
    ];
  };
}
