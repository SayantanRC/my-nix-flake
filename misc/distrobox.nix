{ config, pkgs, username, ... }:

{
  # https://www.youtube.com/watch?v=ztjZRam-Ps4
  virtualisation.podman.enable = true;
  users.users.${username} = {
    extraGroups = [ "podman" ];
  };
  environment.systemPackages = with pkgs; [
    distrobox
  ];
}