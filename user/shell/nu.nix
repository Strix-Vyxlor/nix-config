{
  pkgs,
  userSettings,
  config,
  ...
}: let
  aliases = {
    ls = "eza --icons";
    ll = "eza --icons -l";
    lla = "eza --icons -la";
    tree = "eza --icons --tree";
    plaincat = "^cat";
    cat = "bat --plain";
    neofetch = "fastfetch";
  };
in {
  imports = [
    (./. + "/prompt/" + ("/" + userSettings.prompt) + ".nix")
  ];

  programs.nushell = {
    enable = true;
    shellAliases = aliases;
    extraConfig = ''

      # let's define some colors

      let base00 = "#${config.lib.stylix.colors.base00}" # Default Background
      let base01 = "#${config.lib.stylix.colors.base02}" # Lighter Background (Used for status bars, line number and folding marks)
      let base02 = "#${config.lib.stylix.colors.base02}" # Selection Background
      let base03 = "#${config.lib.stylix.colors.base03}" # Comments, Invisibles, Line Highlighting
      let base04 = "#${config.lib.stylix.colors.base01}" # Dark Foreground (Used for status bars)
      let base05 = "#${config.lib.stylix.colors.base05}" # Default Foreground, Caret, Delimiters, Operators
      let base06 = "#${config.lib.stylix.colors.base06}" # Light Foreground (Not often used)
      let base07 = "#${config.lib.stylix.colors.base07}" # Light Background (Not often used)
      let base08 = "#${config.lib.stylix.colors.base08}" # Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
      let base09 = "#${config.lib.stylix.colors.base09}" # Integers, Boolean, Constants, XML Attributes, Markup Link Url
      let base0a = "#${config.lib.stylix.colors.base0A}" # Classes, Markup Bold, Search Text Background
      let base0b = "#${config.lib.stylix.colors.base0B}" # Strings, Inherited Class, Markup Code, Diff Inserted
      let base0c = "#${config.lib.stylix.colors.base0C}" # Support, Regular Expressions, Escape Characters, Markup Quotes
      let base0d = "#${config.lib.stylix.colors.base0D}" # Functions, Methods, Attribute IDs, Headings
      let base0e = "#${config.lib.stylix.colors.base0E}" # Keywords, Storage, Selector, Markup Italic, Diff Changed
      let base0f = "#${config.lib.stylix.colors.base0F}" # Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>

      # we're creating a theme here that uses the colors we defined above.

      let base16_theme = {
          separator: $base03
          leading_trailing_space_bg: $base04
          header: $base0b
          date: $base0e
          filesize: $base0d
          row_index: $base0c
          bool: $base08
          int: $base0b
          duration: $base08
          range: $base08
          float: $base08
          string: $base04
          nothing: $base08
          binary: $base08
          cellpath: $base08
          hints: dark_gray

          shape_garbage: { fg: $base07 bg: $base08 attr: b} # base16 white on red
          # but i like the regular white on red for parse errors
          # shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
          shape_bool: $base0d
          shape_int: { fg: $base0e attr: b}
          shape_float: { fg: $base0e attr: b}
          shape_range: { fg: $base0a attr: b}
          shape_internalcall: { fg: $base0c attr: b}
          shape_external: $base0c
          shape_externalarg: { fg: $base0b attr: b}
          shape_literal: $base0d
          shape_operator: $base0a
          shape_signature: { fg: $base0b attr: b}
          shape_string: $base0b
          shape_filepath: $base0d
          shape_globpattern: { fg: $base0d attr: b}
          shape_variable: $base0e
          shape_flag: { fg: $base0d attr: b}
          shape_custom: {attr: b}
      }

      $env.config = {
        show_banner: false
        float_precision: 2

        ls: {
          use_ls_colors: true
          clickable_links: true
        }

        table: {
          mode: rounded
          index_mode: always
        }
        filesize: {
          metric: true # true => KB, MB, GB (ISO standard), false => KiB, MiB, GiB (Windows standard)
          format: "auto" # b, kb, kib, mb, mib, gb, gib, tb, tib, pb, pib, eb, eib, auto
        }

        color_config: $base16_theme
      }

      source ~/.config/nushell/zoxide.nu
    '';
    extraEnv = ''
      zoxide init --cmd cd nushell | save -f ~/.config/nushell/zoxide.nu
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  stylix.targets.btop.enable = true;

  home.packages = with pkgs; [
    direnv
    nix-direnv
    eza
    bat
    zoxide
    btop
    fzf
  ];
}
