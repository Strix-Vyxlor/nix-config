{config, ...}: {
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        icon-theme = "Vimix-Ruby-dark";
      };
    };
  };
  stylix.targets.fuzzel.enable = true;
}
