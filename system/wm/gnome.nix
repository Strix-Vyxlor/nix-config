{ pkgs, inputs, ... }:
{
  imports = [
    ./pipewire.nix
    ./dbus.nix
    inputs.stylix.homeManagerModules.stylix
  ];
 
  stylix.targets.gnome.enable = true;

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

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal
    ];
  };

  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  documentation.nixos.enable = false;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gedit
    epiphany
    cheese
    geary
    evince
    totem
    gnome-tour
    gnome-connections
    gnome-calendar
  ]) ++ (with pkgs.gnome; [ 
      gnome-music
      gnome-characters
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      gnome-weather
      gnome-clocks
      gnome-contacts
      gnome-maps
      gnome-logs
  ]);

}
