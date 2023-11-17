{ config, lib, pkgs, ... }:
{
  
  dconf.settings = {
   
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings= [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom99/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom99" = {
      binding="XF86Launch1";
      command="rog-control-center";
      name="ROG control center";
    };

  };  
}
