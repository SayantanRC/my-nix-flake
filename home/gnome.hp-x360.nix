{ config, lib, pkgs, username, ... }:

{
  
  dconf.settings = {
   
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors=["_memory_usage_"];
    };

  };  
}
