{ pkgs, config, userSettings, ...}:
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
in
{
  imports = [
    (./. + "/prompt/" + ("/" + userSettings.prompt) + ".nix")
  ];

  programs.fish = {
    enable = true;
    shellAliases = aliases;
    shellInit = ''
      set fish_greeting
      set -U __done_notification_command "notify-send --app-name \$title \$message"
      
    '';
    shellInitLast = '' 
      
      set -U FZF_COMPLETE 2
      zoxide init --cmd cd fish | source
    '';
    plugins = [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "jethrokuan";
          repo = "fzf";
          rev = "master";
          hash = "sha256-28QW/WTLckR4lEfHv6dSotwkAKpNJFCShxmKFGQQ1Ew=";
        };
      }
      {
        name = "done";
        src = pkgs.fetchFromGitHub {
          owner = "franciscolourenco";
          repo = "done";
          rev = "master";
          hash = "sha256-DMIRKRAVOn7YEnuAtz4hIxrU93ULxNoQhW6juxCoh4o=";
        };
      }
    ];
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  stylix.targets.btop.enable = true;

  home.packages = with pkgs; [
    direnv
    nix-direnv
    eza
    bat
    fd
    zoxide
    btop
    fzf 
  ];
}
