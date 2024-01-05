{ config, pkgs, username, ... }:

{
  # https://www.youtube.com/watch?v=ztjZRam-Ps4
  virtualisation.docker.enable = true;
  users.users.${username} = {
    extraGroups = [ "docker" ];
  };
  environment.systemPackages = with pkgs; [
    distrobox
  ];
}