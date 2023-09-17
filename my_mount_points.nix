{ config, pkgs, ... }:

{
  # Mount linux_shared
  # https://nixos.org/manual/nixos/stable/index.html#ch-file-systems
  # https://discourse.nixos.org/t/how-to-add-second-hard-drive-hdd/6132/2
  fileSystems."/mnt/linux_shared" = {
    device = "/dev/disk/by-label/linux_shared";
    options = [ "nosuid,nodev,nofail,x-gvfs-show" ];
  };
}
