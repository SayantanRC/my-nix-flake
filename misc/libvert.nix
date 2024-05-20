# https://github.com/erictossell/nixflakes/blob/main/modules/virt/libvirt.nix
# https://www.reddit.com/r/NixOS/comments/177wcyi/best_way_to_run_a_vm_on_nixos/

# Share directory:
# https://www.debugpoint.com/share-folder-virt-manager/
# https://www.debugpoint.com/kvm-share-folder-windows-guest/
# Virtiofsd:
# https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752

{ pkgs, username, home-manager, ... }:
{
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;

  users.users.${username}.extraGroups = [ "libvirtd" ];

  environment.systemPackages = with pkgs; [
    spice
    spice-gtk
    spice-protocol
    virt-viewer
    virtio-win
    win-spice
  ];
  programs.virt-manager.enable = true;

  home-manager.users.${username} = {
    dconf.settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };
  };
}