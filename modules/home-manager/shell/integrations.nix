{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.shell.integrations;
  styleCfg = config.strixos.style;
  userCfg = config.strixos.user;
  inherit (config.strixos.shell) defaultShell;
in {
  options.strixos.shell.integrations = {
    vivid = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable vivid LS_COLORS integration for default shell (requires stylix)
      '';
    };
    direnv = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable direnv and nix-direnv for default shell
      '';
    };
    zoxide = mkOption {
      type = types.bool;
      default = false;
      description = ''
        enable zoxide for default shell (replaces cd)
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.vivid (mkMerge [
      {
        home.packages = [pkgs.vivid];
        home.file.".config/strixos/vivid.yml".text = ''
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
      }
      (mkIf (defaultShell == "bash") {
        programs.bash.bashrcExtra = ''
          export LS_COLORS="$(vivid generate /home/${userCfg.username}/.config/strixos/vivid.yml)"
        '';
      })
      (mkIf (defaultShell == "nushell") {
        programs.nushell.extraConfig = ''
          $env.LS_COLORS = (vivid generate /home/${userCfg.username}/.config/strixos/vivid.yml | str trim)
        '';
      })
    ]))
    (mkIf cfg.direnv {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableBashIntegration = defaultShell == "bash";
        enableNushellIntegration = defaultShell == "nushell";
      };
    })
    (mkIf cfg.zoxide {
      programs.zoxide = {
        enable = true;
        options = ["--cmd" "cd"];
        enableBashIntegration = defaultShell == "bash";
        enableNushellIntegration = defaultShell == "nushell";
      };
    })
  ];
}
