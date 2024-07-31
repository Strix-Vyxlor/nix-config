{ pkgs, inputs, ... }:
{
  imports = [ inputs.stylix.nixosModules.stylix ];

  stylix.targets.vim.enable = true;

  home.packages = with pkgs; [
    neovim
  ];

    # TODO: add my neovim config
}
