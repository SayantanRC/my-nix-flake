{ config, lib, pkgs, username, ... }:
{
  
  dconf.settings = {
   
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings= [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom99/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom100/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom99" = {
      binding="XF86Launch1";
      command="rog-control-center";
      name="ROG control center";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom100" = {
      binding="XF86Launch4";
      command="asusctl profile -n";
      name="Performance profile toggle";
    };

  };  
}
