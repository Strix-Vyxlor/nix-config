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
      theme.themeDir = ../../themes/nord;
    };
    xdg = {
      enable = true;
    };
    shell = {
      defaultShell = "bash";
      bash.aliases = {
        ls = "eza";
        ll = "eza -l";
        lla = "eza -la";
        tree = "eza --icons --tree";
        plaincat = "^cat";
        cat = "bat --plain";
      };
      integrations = {
        vivid = true;
        zoxide = true;
      };
    };
    programs = {
      cli = {
        git = {
          enable = true;
          gh = true;
        };
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
    eza
    fzf
  ];

  programs.zix = {
    enable = true;
    config.root_command = "doas";
  };

  home.stateVersion = "25.05";
}
