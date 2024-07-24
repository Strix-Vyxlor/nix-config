{ pkgs, ... }:
{
  imports = [
    ./pipewire.nix
    ./dbus.nix
  ];
 
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon gnome2.GConf ];

  services.printing.enable = true;
  services.xserver = {
    enable = true;
    xkb = {
      layout = "be";
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    epiphany
    cheese
    geary
    evince
    totem
  ]) ++ (with pkgs.gnome; 
    gnome-music
    gnome-characters
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

}
