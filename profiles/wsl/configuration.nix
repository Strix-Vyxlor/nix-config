{
  pkgs,
  lib,
  branch,
  ...
}: {
  strixos = {
    inherit branch;
    hostName = "Strix-Desktop";
    user = {
      username = "strix";
      name = "Strix Vyxlor";
    };
    locale = {
      timezone = "Europe/Brussels";
      locale = "en_US.UTF-8";
    };
    hardware = {
      kernel = "zen";
      graphics = true;
    };
    programs = {
      superuser = "doas";
      git = true;
    };
    services.timesync = "timesyncd";
    style.theme.themeDir = ../../themes/nord;
  };

  wsl = {
    enable = true;
    defaultUser = "strix";
  };

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    helix
    git
    home-manager
  ];

  system.stateVersion = "25.05";
}
