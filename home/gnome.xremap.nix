{ config, lib, pkgs, username, ... }:
{
  home.packages = with pkgs; [
    gnomeExtensions.xremap
  ];
  
  dconf.settings = {
  
    "org/gnome/shell" = {
      enabled-extensions = [
        "xremap@k0kubun.com"
      ];
    };

  };  
}
