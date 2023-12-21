{ config, pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

  # https://srid.ca/lxc-nixos
  # https://discourse.nixos.org/t/howto-setup-lxd-on-nixos-with-nixos-guest-using-unmanaged-bridge-network-interface/21591
  virtualisation.lxd = {
    enable = true;
    ui.enable = true;
    recommendedSysctlSettings = true;
  };
  virtualisation.lxc = {
    lxcfs.enable = true;
  };
  users.users.${username} = {
    extraGroups = [ "lxd" ];
  };
  networking.firewall.extraCommands = ''
    iptables -A INPUT -i lxdbr0 -m comment --comment "my rule for LXD network lxdbr0" -j ACCEPT
  '';
}