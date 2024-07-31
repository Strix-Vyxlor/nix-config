{ pkgs, inputs, ... }:
{
  stylix.targets.vim.enable = true;

  home.packages = with pkgs; [
    neovim
  ];

    # NOTE: im overiding neovim package with my config
}
