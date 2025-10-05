{
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
      theme.themeDir = ../../themes/nord;
      targets.btop = true;
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
    xdg.enable = true;
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
    gnugrep
    gnused
    zip
    unzip
    gzip
    xz
    bat
    eza
    btop
    fzf
  ];

  programs.zix = {
    enable = true;
    config = {
      root_command = "sudo";
      hostname = "wsl";
    };
  };

  home.stateVersion = "25.05";
}
