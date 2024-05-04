{ config, lib, pkgs, username, ... }:
{
  home.packages = with pkgs.unstable; [
    gnomeExtensions.tailscale-qs
  ];
  
  dconf.settings = {
  
    "org/gnome/shell" = {
      enabled-extensions = [
        "tailscale@joaophi.github.com"
      ];
    };

  };  
}
