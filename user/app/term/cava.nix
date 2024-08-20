{ inputs, config, ... }: let
  nc = inputs.nix-colorizer;
  lower = nc.darken (nc.hexToOklch "#${config.lib.stylix.colors.base0D}") 20;
  raise = nc.lighten (nc.hexToOklch "#${config.lib.stylix.colors.base0D}") 20;

  gradient = nc.gradient lower raise 6;

in {
  programs.cava = {
    enable = true;
    settings = {
      colors ={
        gradient = 1;
        gradient_color_1 = "#${builtins.elemAt gradient 0}"; 
        gradient_color_2 = "#${builtins.elemAt gradient 1}";
        gradient_color_3 = "#${builtins.elemAt gradient 2}";
        gradient_color_4 = "#${builtins.elemAt gradient 3}";
        gradient_color_5 = "#${builtins.elemAt gradient 4}";
        gradient_color_6 = "#${builtins.elemAt gradient 5}";
        gradient_color_7 = "#${builtins.elemAt gradient 6}";
        gradient_color_8 = "#${builtins.elemAt gradient 7}";
      };
    };
  };
}
