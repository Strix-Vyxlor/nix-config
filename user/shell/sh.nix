{ pkgs, userSettings, ... }:
let
  aliases = {
    
    zsh = {
      ls = "eza --icons";
      ll = "eza --icons -l";
      lla = "eza --icons -la";
      tree = "eza --icons --tree";
      plaincat = "${pkgs.coreutils}/bin/cat";
      cat = "bat --plain";
      neofetch = "fastfetch";
    };
  };
in {
  # default system prompt
  programs.bash = {
    enable = true;
    enableCompletion = true;
    shellAliases  = {
      ll = "ls -l";
      lla = "ls -la";
      neofetch = "fastfetch";
    };
    bashrcExtra = ''
      PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'
      PS1='\[\e[31m\]\u\[\e[0m\]@\[\e[31m\]\h\[\e[33m\] (''${PS1_CMD1})\[\e[0m\]>\[\e[97m\] \[\e[37m\]\w\n\[\e[33m\]$?\[\e[36;1m\]>\[\e[0;97m\] \[\e[0m\]'
    '';
  };

  home.packages = with pkgs; [
    awk  
    fastfetch
    gnugrep
    gnused
  ];
}
