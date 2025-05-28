{
  config,
  pkgs,
  branch,
  lib,
  ...
}: {
  strixos = {
    inherit branch;
    user = {
      username = "strix";
      name = "Strix Vyxlor";
      email = "strix.vyxlor@gmail.com";
    };
    style.theme.themeDir = ../../themes/nord;
    xdg = {
      enable = true;
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
        };
        tmux.enable = true;
        yazi = {
          enable = true;
          makeDefault = true;
        };
      };
      editor.strixvim = true;
    };
  };

  home.packages = with pkgs; [
    gawk
    gnugrep
    gnused
    htop
    btop
    unzip
    gzip
    xz
    file
    gnutar
    bat
    fzf
  ];

  programs.zix = {
    enable = true;
    config.root_command = "sudo";
  };

  home.stateVersion = "25.05";
}
