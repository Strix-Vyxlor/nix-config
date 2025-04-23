{
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../console/yazi.nix
  ];
  home.packages = with pkgs; [
    neovim
  ];

  home.file.".config/nvim/env.json".text = ''
    {
      "shell": "${userSettings.shell}",
      "file_manager": "yazi"
    }
  '';

  # NOTE: im overiding neovim package with my config
}
