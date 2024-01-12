{ config, pkgs, ... }:

{

  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    kitty
    vim
    bluez
    bluez-tools
  ];

}
