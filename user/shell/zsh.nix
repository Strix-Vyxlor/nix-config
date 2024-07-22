{ pkgs, userSettings, ... }:
let
  aliases = {
    ls = "eza --icons";
    ll = "eza --icons -l";
    lla = "eza --icons -la";
    tree = "eza --icons --tree";
    plaincat = "command cat";
    cat = "bat --plain";
    neofetch = "fastfetch";
  };

  prompt = {
    starship = ''
      eval "''$(starship init zsh)"
    '';
  };
in
{
  imports = [
    (./. + "/prompt/" + ("/" + userSettings.prompt) + ".nix")
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
    shellAliases = aliases;
    initExtraBeforeCompInit = ''
      ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share/}/zinit/zinit.git"

      if [ ! -d ''$ZINIT_HOME ]; then
        mkdir -p "''$(dirname ''$ZINIT_HOME)"
        git clone https://github.com/zdharma-continuum/zinit.git "''$ZINIT_HOME"
      fi

      source "''${ZINIT_HOME}/zinit.zsh"
    
      zinit light zsh-users/zsh-syntax-highlighting
      zinit light zsh-users/zsh-completions
      zinit light zsh-users/zsh-autosuggestions
      zinit light Aloxaf/fzf-tab
    '';

    initExtra = ''
      setopt appendhistory
      setopt sharehistory
      setopt hist_ignore_space
      setopt hist_ignore_all_dups
      setopt hist_save_no_dups
      setopt hist_ignore_dups
      setopt hist_find_no_dups
      
      eval "''$(fzf --zsh)"
      eval "''$(zoxide init --cmd cd zsh)"
    '' + prompt.${userSettings.prompt};
  };

  home.packages = with pkgs; [
    eza
    bat
    zoxide
    btop
    zinit
    fzf
  ];
}
