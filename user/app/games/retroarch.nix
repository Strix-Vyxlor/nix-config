{pkgs, ...}: let
  myRetroarch = pkgs.retroarch.withCores (cores:
    with cores; [
      dolphin
      picodrive
      genesis-plus-gx
    ]);
in {
  home.packages = [
    myRetroarch
  ];
}
