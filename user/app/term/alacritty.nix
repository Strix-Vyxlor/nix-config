{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    alacritty
  ];
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    shell = "zsh";
    window = {
      decorations = "None";
      blur = true;
      opacity = lib.mkForce 0.75;
    };
    font = {
      normal = "ZedMono Nerd Font";
      bold = "ZedMono Nerd Font";
      italic = "ZedMono Nerd Font";
      size = 12;
    };
    cursor = {
      style = {
        shape = "Block";
        blinking = "Always";
      };
    };
  };

  stylix.targets.alacritty.enable = true;
}
