{
  config,
  pkgs,
  lib,
  style ? false,
  ...
}: {
  home.packages = [
    (pkgs.discord.override {
      withVencord = true;
    })
  ];

  home.file =
    if style
    then {
      ".config/Vencord/themes/stylix.css" = config.lib.stylix.colors {
        template = builtins.readFile ./discord.theme.css.mustache;
        extension = ".css";
      };
    }
    else {};
}
