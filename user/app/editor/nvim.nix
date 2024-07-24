{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
  ];

    # TODO: add my neovim config
}
