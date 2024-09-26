{
  inputs,
  config,
  ...
}: let
  nc = inputs.nix-colorizer;
  lower = nc.darken (nc.hexToOklch "#${config.lib.stylix.colors.base0D}") 30;
  raise = nc.lighten (nc.hexToOklch "#${config.lib.stylix.colors.base0D}") 30;

  oklck_gradient = nc.gradient lower raise 6;
  gradient = builtins.concatLists (
    builtins.genList (
      x: [
        (nc.oklchToHex (builtins.elemAt oklck_gradient x))
      ]
    )
    8
  );
in {
  programs.cava = {
    enable = true;
    settings = {
      # color ={
      #   gradient = 1;
      #   gradient_color_1 = "'${(builtins.elemAt gradient 0)}'";
      #   gradient_color_2 = "'${(builtins.elemAt gradient 1)}'";
      #   gradient_color_3 = "'${(builtins.elemAt gradient 2)}'";
      #   gradient_color_4 = "'${(builtins.elemAt gradient 3)}'";
      #   gradient_color_5 = "'${(builtins.elemAt gradient 4)}'";
      #   gradient_color_6 = "'${(builtins.elemAt gradient 5)}'";
      #   gradient_color_7 = "'${(builtins.elemAt gradient 6)}'";
      #   gradient_color_8 = "'${(builtins.elemAt gradient 7)}'";
      # };
      color = {
        gradient = 1;
        gradient_color_1 = "'#${config.lib.stylix.colors.base08}'";
        gradient_color_2 = "'#${config.lib.stylix.colors.base09}'";
        gradient_color_3 = "'#${config.lib.stylix.colors.base0A}'";
        gradient_color_4 = "'#${config.lib.stylix.colors.base0B}'";
        gradient_color_5 = "'#${config.lib.stylix.colors.base0C}'";
        gradient_color_6 = "'#${config.lib.stylix.colors.base0D}'";
        gradient_color_7 = "'#${config.lib.stylix.colors.base0E}'";
        gradient_color_8 = "'#${config.lib.stylix.colors.base0F}'";
      };
    };
  };
}
