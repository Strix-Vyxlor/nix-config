{pkgs, ...}: {
  home.file.".config/Vencord/themes/stylix.css".source = pkgs.fetchurl {
    url = "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css";
    hash = "sha256-madm8UuK6rkmnYMpWpEOMghADZvui1xMix6R9YaCO3k=";
  };

  gtk.cursorTheme = {
    package = pkgs.vimix-cursors;
    name = "Vimix-cursors";
    size = 24;
  };

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
