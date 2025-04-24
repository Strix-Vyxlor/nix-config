{
  pkgs,
  userSettings,
  ...
}: let
in {
  programs.steam = {
    enable = true;
    protontricks.enable = true;
    #extest.enable = true;
    extraPackages = [
      pkgs.mangohud
    ];
  };
}
