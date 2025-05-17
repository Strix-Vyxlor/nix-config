{
  config,
  pkgs,
  branch,
  ...
}: {
  strixos = {
    inherit branch;
    user = {
      username = "gamer";
    };
    style = {
      theme.themeDir = ../../../themes/nord;
      desktop = {
        enable = true;
      };
    };
    xdg = {
      enable = true;
      mime = true;
    };
    shell = {
      defaultShell = "bash";
      nushell = {
        aliases = {
          ll = "ls -l";
          lla = "ls -la";
          plaincat = "command cat";
          cat = "bat --plain";
          neofetch = "fastfetch";
        };
      };
      integrations = {
        vivid = true;
        zoxide = true;
      };
    };
    programs = {
      cli = {
        tmux.enable = true;
      };
      editor.strixvim = true;
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
    fzf

    nemo
    xarchiver

    dolphin-emu
  ];

  home.file."ROMs/desktop/nemo.desktop".source = "${pkgs.nemo}/share/application/nemo.desktop";
  home.file."ROMs/desktop/dolphin-emu.desktop".source = "${pkgs.dolphin-emu.desktop}/share/application/dolphin-emu.desktop";

  xdg.mimeApps = {
    defaultApplications = {
      "application/zip" = "xarchiver.desktop";
      "application/x-compressed-tar" = "xarchiver.desktop";
      "application/x-xz-compressed-tar" = "xarchiver.desktop";
      "application/x-bzip2-compressed-tar" = "xarchiver.desktop";
      "application/x-tar" = "xarchiver.desktop";
    };
    associations = {
      added = {
        "application/zip" = "xarchiver.desktop";
        "application/x-compressed-tar" = "xarchiver.desktop";
        "application/x-xz-compressed-tar" = "xarchiver.desktop";
        "application/x-bzip2-compressed-tar" = "xarchiver.desktop";
        "application/x-tar" = "xarchiver.desktop";
      };
    };
  };

  programs.zix = {
    enable = true;
    config.root_command = "sudo";
  };

  home.stateVersion = "25.05";
}
