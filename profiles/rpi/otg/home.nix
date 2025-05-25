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
      theme.generateWithImage = ../../../themes/background/starry-night.jpg;
    };
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
          gh = true;
        };
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
    kitty.terminfo
  ];

  programs.zix = {
    enable = true;
    config.root_command = "doas";
  };

  home.stateVersion = "25.05";
}
