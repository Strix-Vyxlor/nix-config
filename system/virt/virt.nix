{ config, pkgs, ... }:

{

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Various packages related to virtualization, compatability and sandboxing
  environment.systemPackages = with pkgs; [
    # Virtual Machines and wine
    libvirt
    virt-manager
    qemu
    uefi-run

    # Filesystems
    dosfstools
  ];
}
