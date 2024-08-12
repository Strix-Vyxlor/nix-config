{ pkgs, ... }:
{
  services.udev = {
    packages = with pkgs; [
      platformio-core.udev
      openocd
    ];
    # extraRules = builtins.readFile ./udev/99-platformio-udev.rules;
  };
}
