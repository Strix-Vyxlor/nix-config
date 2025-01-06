{
  pkgs,
  lib,
  userSettings,
  ...
}: let
  shell_pkg =
    if (userSettings.shell == "nu")
    then pkgs.nushell
    else pkgs."${userSettings.shell}";
in {
  home.packages = with pkgs; [
    kitty
  ];
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "ZedMono NF";
      bold_font = "ZedMono NF";
      italic_font = "ZedMono NF";
      bold_italic_font = "ZedMono NF";
      font_size = 12.0;

      cursor_shape = "block";

      background_opacity = lib.mkForce 0.75;

      shell = "${shell_pkg}/bin/${userSettings.shell}";
    };
  };

  stylix.targets.kitty = {
    enable = true;
    variant256Colors = true;
  };
}
