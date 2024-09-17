{ pkgs, userSettings, ...}:
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

  programs.nushell = {
    enable = true; 
    shellAliases = aliases;
    extraConfig = ''
      $env.config = {
        show_banner: false,
      }
      zoxide init --cmd cd nushell | save -f ~/.config/nushell/zoxide.nu
    '';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  stylix.targets.btop.enable = true;

  home.packages = with pkgs; [
    direnv
    nix-direnv
    eza
    bat
    zoxide
    btop
    fzf 
  ];
}
