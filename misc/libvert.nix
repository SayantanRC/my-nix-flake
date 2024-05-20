# https://github.com/erictossell/nixflakes/blob/main/modules/virt/libvirt.nix
# https://www.reddit.com/r/NixOS/comments/177wcyi/best_way_to_run_a_vm_on_nixos/

# WINDOWS Stuff
#
# 1. HOST - Set "Video" to "Virtio".
# 2. GUEST - Install VirtIO drivers after mounting ISO:
# https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/
# 3. GUEST - Install spice guest tools:
# https://www.spice-space.org/download.html#windows-binaries
# 4. HOST - Enable 3D Acceleration:
# https://discourse.nixos.org/t/opengl-can-not-be-used-with-libvirt/43688/6
# 5. Share a folder:
# https://www.debugpoint.com/kvm-share-folder-windows-guest/
# Virtiofsd (may be optional):
# https://discourse.nixos.org/t/virt-manager-cannot-find-virtiofsd/26752

# More on share directory:
# https://www.debugpoint.com/share-folder-virt-manager/

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
    virtiofsd
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