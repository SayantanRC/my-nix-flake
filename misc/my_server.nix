{ config, pkgs, ... }:

{
  # Raspberry pi static ip
  networking.extraHosts = ''
    192.168.29.200 p1cashe3
  '';
}
