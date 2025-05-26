{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.strixos.style.desktop;
  themeCfg = config.strixos.style.theme;
  normalize = color: let
    num = builtins.fromJSON ''{"num": ${color}.0}'';
    norm = num.num / 255;
  in
    builtins.toString norm;
in {
  config = {
    home.file = {
      ".config/cosmic/com.system76.CosmicTk/v1/icon_theme".text = ''"${cfg.icons.name}"'';
      ".config/cosmic/com.system76.CosmicTk/v1/interface_font".text = ''
        (
            family: "${cfg.font.default.name}",
            weight: Normal,
            stretch: Normal,
            style: Normal,
        )
      '';
      ".config/cosmic/com.system76.CosmicTk/v1/monospace_font".text = ''
        (
            family: "${cfg.font.monospace.name}",
            weight: Normal,
            stretch: Normal,
            style: Normal,
        )
      '';
      ".config/cosmic/com.system76.CosmicTheme.Mode/v1/is_dark".text = ''${
          if (themeCfg.polarity == "dark")
          then "true"
          else "false"
        }'';
      ".config/cosmic/com.system76.CosmicTheme.Dark/v1/accent".text = with config.lib.stylix.colors; ''
          (
            base: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            hover: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 1.0,
            ),
            pressed: (
                red: 0.5,
                green: 0.01695135,
                blue: 0.14466447,
                alpha: 1.0,
            ),
            selected: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 1.0,
            ),
            selected_text: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            focus: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            divider: (
                red: 0.0,
                green: 0.0,
                blue: 0.000000000000000000000000000000000000000000036,
                alpha: 1.0,
            ),
            on: (
                red: 0.0,
                green: 0.0,
                blue: 0.000000000000000000000000000000000000000000036,
                alpha: 1.0,
            ),
            disabled: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            on_disabled: (
                red: 0.5,
                green: 0.0,
                blue: 0.000000000000000000000000000000000000000000018,
                alpha: 1.0,
            ),
            border: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            disabled_border: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 0.5,
            ),
        )
      '';
      ".config/cosmic/com.system76.CosmicTheme.Dark/v1/accent_button".text = with config.lib.stylix.colors; ''
          (
            base: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            hover: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 1.0,
            ),
            pressed: (
                red: 0.5,
                green: 0.01695135,
                blue: 0.14466447,
                alpha: 1.0,
            ),
            selected: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 1.0,
            ),
            selected_text: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            focus: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            divider: (
                red: 0.0,
                green: 0.0,
                blue: 0.000000000000000000000000000000000000000000036,
                alpha: 1.0,
            ),
            on: (
                red: 0.0,
                green: 0.0,
                blue: 0.000000000000000000000000000000000000000000036,
                alpha: 1.0,
            ),
            disabled: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            on_disabled: (
                red: 0.5,
                green: 0.0,
                blue: 0.000000000000000000000000000000000000000000018,
                alpha: 1.0,
            ),
            border: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 1.0,
            ),
            disabled_border: (
                red: ${normalize base0D-rgb-r},
                green: ${normalize base0D-rgb-g},
                blue: ${normalize base0D-rgb-b},
                alpha: 0.5,
            ),
        )
      '';
      ".config/cosmic/com.system76.CosmicTheme.Dark/v1/background".text = with config.lib.stylix.colors; ''
          (
            base: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 1.0,
            ),
            component: (
                base: (
                    red: ${normalize base02-rgb-r},
                    green: ${normalize base02-rgb-g},
                    blue: ${normalize base02-rgb-b},
                    alpha: 1.0,
                ),
                hover: (
                    red: 0.99998415,
                    green: 0.4977462,
                    blue: 0.4359769,
                    alpha: 1.0,
                ),
                pressed: (
                    red: 0.9999683,
                    green: 0.5535522,
                    blue: 0.49864614,
                    alpha: 1.0,
                ),
                selected: (
                    red: 0.99998415,
                    green: 0.4977462,
                    blue: 0.4359769,
                    alpha: 1.0,
                ),
                selected_text: (
                    red: 0.635294,
                    green: 0.517647,
                    blue: 0.647059,
                    alpha: 1.0,
                ),
                focus: (
                    red: 0.635294,
                    green: 0.517647,
                    blue: 0.647059,
                    alpha: 1.0,
                ),
                divider: (
                    red: 0.0,
                    green: 0.0001637691,
                    blue: 0.00000000018801075,
                    alpha: 0.2,
                ),
                on: (
                    red: ${normalize base05-rgb-r},
                    green: ${normalize base05-rgb-g},
                    blue: ${normalize base05-rgb-b},
                    alpha: 1.0,
                ),
                disabled: (
                    red: 1.0,
                    green: 0.44194025,
                    blue: 0.37330768,
                    alpha: 1.0,
                ),
                on_disabled: (
                    red: 0.5,
                    green: 0.221052,
                    blue: 0.18665384,
                    alpha: 1.0,
                ),
                border: (
                    red: 0.61552477,
                    green: 0.74232894,
                    blue: 1.0,
                    alpha: 1.0,
                ),
                disabled_border: (
                    red: 0.61552477,
                    green: 0.74232894,
                    blue: 1.0,
                    alpha: 0.5,
                ),
            ),
            divider: (
                red: ${normalize base01-rgb-r},
                green: ${normalize base01-rgb-g},
                blue: ${normalize base01-rgb-b},
                alpha: 1.0,
            ),
            on: (
                red: ${normalize base05-rgb-r},
                green: ${normalize base05-rgb-g},
                blue: ${normalize base05-rgb-b},
                alpha: 1.0,
            ),
            small_widget: (
                red: 0.5933852,
                green: 0.59747267,
                blue: 0.62433136,
                alpha: 0.25,
            ),
        )
      '';

      ".config/cosmic/com.system76.CosmicTheme.Dark/v1/primary".text = with config.lib.stylix.colors; ''
          (
            base: (
                red: ${normalize base01-rgb-r},
                green: ${normalize base01-rgb-g},
                blue: ${normalize base01-rgb-b},
                alpha: 1.0,
            ),
            component: (
                base: (
                    red: 1.0,
                    green: 0.8936537,
                    blue: 0.875448,
                    alpha: 1.0,
                ),
                hover: (
                    red: 0.99998415,
                    green: 0.90428835,
                    blue: 0.8879032,
                    alpha: 1.0,
                ),
                pressed: (
                    red: 0.9999683,
                    green: 0.91492295,
                    blue: 0.9003584,
                    alpha: 1.0,
                ),
                selected: (
                    red: 0.99998415,
                    green: 0.90428835,
                    blue: 0.8879032,
                    alpha: 1.0,
                ),
                selected_text: (
                    red: 0.635294,
                    green: 0.517647,
                    blue: 0.647059,
                    alpha: 1.0,
                ),
                focus: (
                    red: 0.635294,
                    green: 0.517647,
                    blue: 0.647059,
                    alpha: 1.0,
                ),
                divider: (
                    red: 0.07230099,
                    green: 0.14566424,
                    blue: 0.06655153,
                    alpha: 0.2,
                ),
                on: (
                    red: ${normalize base05-rgb-r},
                    green: ${normalize base05-rgb-g},
                    blue: ${normalize base05-rgb-b},
                    alpha: 1.0,
                ),
                disabled: (
                    red: 1.0,
                    green: 0.8936537,
                    blue: 0.875448,
                    alpha: 1.0,
                ),
                on_disabled: (
                    red: 0.5361505,
                    green: 0.519659,
                    blue: 0.47099975,
                    alpha: 1.0,
                ),
                border: (
                    red: 0.61552477,
                    green: 0.74232894,
                    blue: 1.0,
                    alpha: 1.0,
                ),
                disabled_border: (
                    red: 0.61552477,
                    green: 0.74232894,
                    blue: 1.0,
                    alpha: 0.5,
                ),
            ),
            divider: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 1.0,
            ),
            on: (
                red: ${normalize base05-rgb-r},
                green: ${normalize base05-rgb-g},
                blue: ${normalize base05-rgb-b},
                alpha: 1.0,
            ),
            small_widget: (
                red: 0.76724774,
                green: 0.7773921,
                blue: 0.80496025,
                alpha: 0.25,
            ),
        )
      '';

      ".config/cosmic/com.system76.CosmicTheme.Dark/v1/button".text = with config.lib.stylix.colors; ''
        (
            base: (
                red: ${normalize base02-rgb-r},
                green: ${normalize base02-rgb-g},
                blue: ${normalize base02-rgb-b},
                alpha: 0.25,
            ),
            hover: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 0.4,
            ),
            pressed: (
                red: ${normalize base01-rgb-r},
                green: ${normalize base01-rgb-g},
                blue: ${normalize base01-rgb-b},
                alpha: 0.625,
            ),
            selected: (
                red: 0.42862746,
                green: 0.42862746,
                blue: 0.42862746,
                alpha: 0.4,
            ),
            selected_text: (
                red: 0.3882353,
                green: 0.8156863,
                blue: 0.8745098,
                alpha: 1.0,
            ),
            focus: (
                red: 0.3882353,
                green: 0.8156863,
                blue: 0.8745098,
                alpha: 1.0,
            ),
            divider: (
                red: 0.7532969,
                green: 0.7532969,
                blue: 0.75329685,
                alpha: 0.2,
            ),
            on: (
                red: 0.7532969,
                green: 0.7532969,
                blue: 0.75329685,
                alpha: 1.0,
            ),
            disabled: (
                red: 0.51056147,
                green: 0.51056147,
                blue: 0.51056147,
                alpha: 0.34375,
            ),
            on_disabled: (
                red: 0.5107661,
                green: 0.5107661,
                blue: 0.5107661,
                alpha: 0.625,
            ),
            border: (
                red: 0.7764706,
                green: 0.7764706,
                blue: 0.7764706,
                alpha: 1.0,
            ),
            disabled_border: (
                red: 0.7764706,
                green: 0.7764706,
                blue: 0.7764706,
                alpha: 0.5,
            ),
        )
      '';
      ".config/cosmic/com.system76.CosmicTheme.Dark/v1/text_button".text = with config.lib.stylix.colors; ''
        (
            base: (
                red: 0.0,
                green: 0.0,
                blue: 0.0,
                alpha: 0.0,
            ),
            hover: (
                red: ${normalize base02-rgb-r},
                green: ${normalize base02-rgb-g},
                blue: ${normalize base02-rgb-b},
                alpha: 0.2,
            ),
            pressed: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 0.5,
            ),
            selected: (
                red: ${normalize base00-rgb-r},
                green: ${normalize base00-rgb-g},
                blue: ${normalize base00-rgb-b},
                alpha: 0.2,
            ),
            selected_text: (
                red: 0.635294,
                green: 0.513725,
                blue: 0.647059,
                alpha: 1.0,
            ),
            focus: (
                red: 0.635294,
                green: 0.513725,
                blue: 0.647059,
                alpha: 1.0,
            ),
            divider: (
                red: 0.635294,
                green: 0.513725,
                blue: 0.647059,
                alpha: 0.2,
            ),
            on: (
                red: 0.635294,
                green: 0.513725,
                blue: 0.647059,
                alpha: 1.0,
            ),
            disabled: (
                red: 0.0,
                green: 0.0,
                blue: 0.0,
                alpha: 0.0,
            ),
            on_disabled: (
                red: 0.317647,
                green: 0.2568625,
                blue: 0.3235295,
                alpha: 0.5,
            ),
            border: (
                red: 1.0,
                green: 0.6307857,
                blue: 0.57441425,
                alpha: 1.0,
            ),
            disabled_border: (
                red: 1.0,
                green: 0.6307857,
                blue: 0.57441425,
                alpha: 0.5,
            ),
        )

      '';
    };
  };
}
