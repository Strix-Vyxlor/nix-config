{
  pkgs,
  userSettings,
  config,
  ...
}: let
  aliases = {
    ll = "ls -l";
    lla = "ls -la";
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
      let base01 = "#${config.lib.stylix.colors.base03}" # Lighter Background (Used for status bars, line number and folding marks)
      let base02 = "#${config.lib.stylix.colors.base02}" # Selection Background
      let base03 = "#${config.lib.stylix.colors.base03}" # Comments, Invisibles, Line Highlighting
      let base04 = "#${config.lib.stylix.colors.base04}" # Dark Foreground (Used for status bars)
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

        # shape_garbage: { fg: $base07 bg: $base08 attr: b} # base16 white on red
        # but i like the regular white on red for parse errors
        shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: b}
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
      $env.LS_COLORS = (vivid generate ~/.config/nushell/vivid.yml | str trim)

      def lsblk [...args: string] {
        if ($args | length) != 0 {
          if $args.0 == "--help" {
            ^lsblk --help
            return;
        }}
        let disks = ^lsblk ...$args
        let header = $disks | head -n 1 | tr -s " " | split row " "
        let list = $disks | tr -s " " | split row "\n" | each { |row| | split row " " } | skip 1
        let all = [ $header ] | append $list
        $all |
          each { |values|
            reduce -f {} { |it,acc|
              $acc | insert $"Field($acc | transpose | length)" $it
          }
        } | headers
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
  home.file.".config/nushell/vivid.yml".text = ''
    colors:
      base0:  '${config.lib.stylix.colors.base00}'  # background
      base1:  '${config.lib.stylix.colors.base01}'  # black
      base2:  '${config.lib.stylix.colors.base02}'  # selection
      base3:  '${config.lib.stylix.colors.base03}'  # brightblack
      base4:  '${config.lib.stylix.colors.base04}'  # foreground
      base5:  '${config.lib.stylix.colors.base05}'  # white
      base6:  '${config.lib.stylix.colors.base06}'  # brightwhite
      base7:  '${config.lib.stylix.colors.base07}'  # brightcyan
      base8:  '${config.lib.stylix.colors.base0C}'  # cyan
      base9:  '${config.lib.stylix.colors.base0D}'  # blue
      base10: '${config.lib.stylix.colors.base0E}'  # darkblue
      base11: '${config.lib.stylix.colors.base08}'  # red
      base12: '${config.lib.stylix.colors.base09}'  # orange
      base13: '${config.lib.stylix.colors.base0A}'  # yellow
      base14: '${config.lib.stylix.colors.base0B}'  # green
      base15: '${config.lib.stylix.colors.base0F}'  # magenta

      dim-foreground: '${config.lib.stylix.colors.base04}'

    core:
      normal_text:
        foreground: dim-foreground

      reset_to_normal:
        background: base0
        foreground: base4
        font-style: regular

    # File Types

      regular_file:
        foreground: base4

      directory:
        foreground: base10  # base9
        font-style: bold

      multi_hard_link:
        foreground: base8
        font-style: underline

      symlink:
        foreground: base8

      broken_symlink:
        foreground: base11

      missing_symlink_target:
        # NOTE: Also used for readline completion shell builtin and function suffix
        background: base11
        foreground: base5  # base4
        font-style: bold

      fifo:
        foreground: base7
        font-style:
          - bold
          - underline

      character_device:
        foreground: base13

      block_device:
        foreground: base13
        font-style: underline

      door:
        foreground: base13
        font-style: italic

      socket:
        # NOTE: Swapped with block device as used for readline completion prefix
        foreground: base13
        font-style: bold

    # File Permissions

      executable_file:
        foreground: base7
        font-style: bold

      file_with_capability:
        foreground: base4
        font-style:
          - bold
          - underline

      setuid:
        foreground: base4
        font-style:
          - bold
          - underline

      setgid:
        foreground: base4
        font-style:
          - bold
          - underline

      sticky:
        background: base10  # base9
        foreground: base5   # base4
        font-style: underline

      other_writable:
        background: base10  # base9
        foreground: base5   # base4
        font-style: bold

      sticky_other_writable:
        background: base10  # base9
        foreground: base5   # base4
        font-style:
          - bold
          - underline

    # Document Types

    archives:
      foreground: base5
      font-style: bold

    executable:
      foreground: base7
      font-style: bold

    markup:
      foreground: base6
      web:
        foreground: base4

    media:
      foreground: base15
      fonts:
        foreground: base4

    office:
      foreground: base14

    programming:
      source:
        foreground: base7
      tooling:
        foreground: base4

    text:
      foreground: base4

    unimportant:
      foreground: base3
  '';

  home.packages = with pkgs; [
    direnv
    nix-direnv
    eza
    bat
    zoxide
    btop
    fzf
    vivid
  ];
}
