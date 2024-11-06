{pkgs, ...}: {
  home.packages = with pkgs; [
    # CC
    gcc_multi
    glibc_multi
    gnumake
    cmake
    autoconf
    automake
    libtool
  ];
}
