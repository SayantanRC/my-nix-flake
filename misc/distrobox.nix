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

  # Distrobox commands
  # Create:           distrobox-create --name Debian-latest-1 --image debian:latest
  # List:             distrobox-list
  # Enter:            distrobox-enter --name Debian-latest-1
  # Export (inside):  distrobox-export --app flameshot
  # Stop:             distrobox-stop Debian-latest-1
  # Delete:           distrobox-rm Debian-latest-1
}