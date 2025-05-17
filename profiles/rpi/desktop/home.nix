{
  config,
  pkgs,
  branch,
  ...
}: {
  strixos = {
    inherit branch;
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      email = "strix.vyxlor@gmail.com";
    };
    style = {
      theme.themeDir = ../../../themes/nord;
      targets.btop = true;
      desktop = {
        enable = true;
      };
    };
    xdg = {
      enable = true;
      userDirs = true;
      mime = true;
    };
    shell = {
      defaultShell = "nushell";
      nushell = {
        aliases = {
          ll = "ls -l";
          lla = "ls -la";
          tree = "eza --icons --tree";
          plaincat = "^cat";
          cat = "bat --plain";
          neofetch = "fastfetch";
        };
      };
      prompt = {
        prompt = "oh-my-posh";
      };
      integrations = {
        vivid = true;
        direnv = true;
        zoxide = true;
      };
    };
    programs = {
      cli = {
        git = {
          enable = true;
          gh = true;
        };
        tmux.enable = true;
      };
      editor.strixvim = true;
      browser = {
        floorp = {
          enable = true;
          makeDefault = true;
        };
      };
    };
    desktop = {
      hyprland = {
        enable = true;
        hyprcursorTheme = "Nordzy-Hyprcursors";
        keymap = "be";
        monitors = [
        ];
        extraSettings = {
          exec-once = [
            "nm-applet"
            "blueberry-tray"
          ];
        };
        apps = {
          lock = null;

          waybar = {
            temperature = true;
          };
        };
      };
    };
  };

  home.packages = with pkgs; [
    gnused
    gnugrep
    htop
    unzip
    gzip
    xz
    file
    gnutar
    bat
    eza
    fzf
    btop
    blueberry
    networkmanagerapplet
  ];

  programs.zix = {
    enable = true;
    config.root_command = "doas";
  };

  home.stateVersion = "25.05";
}
