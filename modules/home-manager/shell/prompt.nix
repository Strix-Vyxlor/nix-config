{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf mkMerge;
  cfg = config.strixos.shell.prompt;
  styleCfg = config.strixos.style;
  inherit (config.strixos.shell) defaultShell;
in {
  options.strixos.shell.prompt = {
    prompt = mkOption {
      type = types.nullOr (types.enum [
        "oh-my-posh"
      ]);
      default = null;
      description = ''
        external prompt to use
      '';
    };
  };

  config = mkIf (cfg.prompt != null) (mkMerge [
    (mkIf (cfg.prompt == "oh-my-posh") {
      programs.oh-my-posh = {
        enable = true;
        enableBashIntegration = defaultShell == "bash";
        enableNushellIntegration = defaultShell == "nushell";
        settings = builtins.fromJSON ''
          {
            "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
            "palette": {
              "main-bg": "#${config.lib.stylix.colors.base01}",
              "orange": "#${config.lib.stylix.colors.base0D}",
              "green": "#${config.lib.stylix.colors.base0B}",
              "red": "#${config.lib.stylix.colors.base08}",
              "teal": "#${config.lib.stylix.colors.base0C}",
              "blue": "#${config.lib.stylix.colors.base08}",
              "maroon": "#${config.lib.stylix.colors.base0E}",
              "yellow": "#${config.lib.stylix.colors.base0A}",
              "purple": "#${config.lib.stylix.colors.base0A}",
              "sky": "#${config.lib.stylix.colors.base0C}"
            },
            "blocks": [
              {
                "alignment": "left",
               "segments": [
                  {
                    "background": "p:main-bg",
                    "foreground": "p:orange",
                    "leading_diamond": "\ue0b6",
                    "properties": {
                      "style": "mixed"
                    },
                    "style": "diamond",
                    "template": "\ue5ff  {{ .Path }}",
                    "trailing_diamond": "\ue0b4",
                    "type": "path"
                  },
                  {
                    "background": "p:main-bg",
                    "foreground": "p:teal",
                    "foreground_templates": [
                      "{{ if or (.Working.Changed) (.Staging.Changed) }}p:orange{{ end }}",
                      "{{ if and (gt .Ahead 0) (gt .Behind 0) }}p:red{{ end }}",
                      "{{ if gt .Ahead 0 }}p:purple{{ end }}",
                      "{{ if gt .Behind 0 }}p:purple{{ end }}"
                    ],
                    "leading_diamond": " \ue0b6",
                    "properties": {
                      "branch_max_length": 25,
                      "fetch_stash_count": true,
                      "fetch_status": true,
                      "fetch_upstream_icon": true
                    },
                    "style": "diamond",
                    "template": " {{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }} \uf044 {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }} \uf046 {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }} \ueb4b {{ .StashCount }}{{ end }} ",
                    "trailing_diamond": "\ue0b4",
                    "type": "git"
                  },

                  {
                    "foreground": "p:red",
                    "style": "plain",
                    "template": " \uea87 ",
                    "type": "status"
                  }
                ],
                "type": "prompt"
              },
               {
                "alignment": "right",
                "segments": [
                  {
                    "background": "p:main-bg",
                    "foreground": "p:sky",
                    "leading_diamond": "\ue0b6",
                    "properties": {
                      "style": "mixed"
                    },
                    "style": "diamond",
                    "template": "{{ if .Env.IN_NIX_SHELL }}\udb84\udd05 ({{ .Env.IN_NIX_SHELL }}){{ end }}",
                    "trailing_diamond": "\ue0b4",
                    "type": "text"
                  },

                  {
                    "foreground": "p:green",
                    "properties": {
                      "display_mode": "files",
                      "fetch_package_manager": true,
                      "fetch_version": true,
                      "npm_icon": "<p:red>\ue71e npm</> ",
                      "yarn_icon":"<p:teal>\uf487 yarn</> "
                    },
                    "style": "plain",
                    "template": "{{ if .PackageManagerIcon }}{{ .PackageManagerIcon }} {{ end }}\ue718 {{ .Full }}",
                    "type": "node"
                  },
                  {
                    "foreground": "p:blue",
                    "properties": {
                      "display_mode": "files",
                      "fetch_version": true
                    },
                    "style": "plain",
                    "template": " {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}",
                    "type": "crystal"
                  },
                  {
                    "foreground": "p:maroon",
                    "properties": {
                      "display_mode": "files",
                      "fetch_version": true
                    },
                    "style": "plain",
                    "template": " {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}",
                    "type": "ruby"
                  },
                  {
                    "foreground": "p:yellow",
                    "properties": {
                      "display_mode": "context",
                      "fetch_virtual_env": false
                    },
                    "style": "plain",
                    "template": " {{ if .Error }}{{ .Error }}{{ else }}{{ .Full }}{{ end }}",
                    "type": "python"
                  }
                ],
                "type": "prompt"
              },
              {
                "alignment": "left",
                "newline": true,
                "segments": [
                  {
                    "foreground": "p:yellow",
                    "style": "plain",
                    "template": "\uf105 ",
                    "type": "text"
                  }
                ],
                "type": "prompt"
              }
            ],
            "secondary_prompt": {
              "background": "transparent",
              "foreground": "p:yellow",
              "template": "\uf105 "
            },
            "transient_prompt": {
              "background": "transparent",
              "foreground": "p:yellow",
              "template": "\ueb70 "
            },
            "version": 2
          }
        '';
      };
    })
  ]);
}
