{ pkgs, inputs, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ]; 

  stylix.cursor = {
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 24;
  };

  gtk.iconTheme = {
    package = pkgs.vimix-icon-theme;
    name = "Vimix-Black-dark";
  };
}
