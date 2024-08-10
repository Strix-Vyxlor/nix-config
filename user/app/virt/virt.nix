{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Virtual Machines and wine
    libvirt
    virt-manager
    qemu
    uefi-run
    swtpm

    # Filesystems
    dosfstools
  ];

  home.file.".config/libvirt/qemu.conf".text = ''
    nvram = ["/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd"]
  '';

}
