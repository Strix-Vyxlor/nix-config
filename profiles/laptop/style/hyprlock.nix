background: {
  config,
  lib,
  pkgs,
  ...
}: let
  hexToInt = hex:
    (builtins.fromTOML ''
      num = 0x${hex}
    '').num;

  intToFloat = int:
    (builtins.fromTOML ''
      num = ${toString int}.0
    '').num;

  hexToRgba = hex: let
    # Ensure exactly 8 characters (RGBA)
    padded =
      if builtins.stringLength hex == 9
      then builtins.substring 1 8 hex
      else throw "Hex string must be 8 characters (RGBA) ${hex}";

    r = hexToInt (builtins.substring 0 2 padded);
    g = hexToInt (builtins.substring 2 2 padded);
    b = hexToInt (builtins.substring 4 2 padded);
    a = hexToInt (builtins.substring 6 2 padded);
  in "rgba(${toString r},${toString g},${toString b},${toString ((intToFloat a) / 255)})";
in {
  programs.hyprlock = lib.mkForce {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };
      auth = {
        "fingerprint:enabled" = true;
      };
      background = {
        path = "${background}";
        color = hexToRgba "${config.programs.matugen.theme.colors.background.default.color}ff";
        blur_passes = 2;
        blur_size = 5;
        noise = 0.0117;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };
      input-field = {
        size = "300, 60";
        outline_thickness = 2;
        dots_size = 0.33;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = hexToRgba "#00000000";
        inner_color = hexToRgba "${config.programs.matugen.theme.colors.surface_container.default.color}38";
        font_color = hexToRgba "${config.programs.matugen.theme.colors.on_surface.default.color}ff";
        font_family = "JetBrains Mono Medium";
        fade_on_empty = false;
        placeholder_text = "<i>󰌾 Enter Pass</i>"; # Text rendered in the input box when it's empty.
        hide_input = false;
        check_color = hexToRgba "${config.programs.matugen.theme.colors.tertiary.default.color}ff";
        fail_color = hexToRgba "${config.programs.matugen.theme.colors.error.default.color}ff";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
        position = "0, -280";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          text = ''cmd[update:1000] echo "<span>$(date +"%I")</span>"'';
          color = hexToRgba "${config.programs.matugen.theme.colors.on_background.default.color}ff";
          font_size = 135;
          font_family = "JetBrains Mono Extrabold";
          position = "-65, 240";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:1000] echo "<span>$(date +"%M")</span>"'';
          color = hexToRgba "${config.programs.matugen.theme.colors.primary.default.color}ff";
          font_size = 135;
          font_family = "JetBrains Mono Extrabold";
          position = "0, 90";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:1000] echo "<span>$(date +"%d %B, %a.")</span>"'';
          color = hexToRgba "${config.programs.matugen.theme.colors.on_background.default.color}ff";
          font_size = 17;
          font_family = "JetBrains Mono Medium";
          position = "10, -8";
          halign = "center";
          valign = "center";
        }
        {
          text = "    $USER";
          color = hexToRgba "${config.programs.matugen.theme.colors.on_background.default.color}ff";
          font_size = 19;
          font_family = "JetBrains Mono Medium";

          position = "0, -220";
          halign = "center";
          valign = "center";
        }
        {
          text = ''cmd[update:1000] echo "<span>$(${pkgs.writeShellScript "hyprlock-song" ''
              song_info=$(${pkgs.playerctl}/bin/playerctl metadata --format '{{title}}     {{artist}}')

              echo "$song_info"
            ''})</span>"'';
          color = hexToRgba "${config.programs.matugen.theme.colors.on_background.default.color}ff";
          font_size = 16;
          font_family = "JetBrains Mono Medium";
          position = "0, 20";
          halign = "center";
          valign = "bottom";
        }
      ];
    };
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    #jetbrains-mono
  ];
}
