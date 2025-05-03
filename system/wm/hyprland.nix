{
  config,
  pkgs,
  lib,
  ...
}: {
  services.displayManager.ly = {
    enable = true;
    settings = {
      clock = "%I:%M:%S %p\n%A %d %B";
      bigclock = true;
      clear_password = true;
      animation = "matrix";
      cmatrix_fg = "0x06";
    };
  };
}
