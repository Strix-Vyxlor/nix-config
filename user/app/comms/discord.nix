{ pkgs, lib, ... }:
{

  home.packages = [
    (pkgs.discord.override {
      withVencord = true;
    })
  ];
}
