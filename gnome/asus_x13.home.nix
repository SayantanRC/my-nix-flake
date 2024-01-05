{ config, lib, pkgs, username, ... }:

{
  
  dconf.settings = {
   
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings= [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom100/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom101/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom102/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom100" = {
      binding="XF86Launch1";
      command="rog-control-center";
      name="ROG control center";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom101" = {
      binding="XF86Launch4";
      command="fan-speed-toggle";
      name="Fan speed toggle";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom102" = {
      binding="<Shift>XF86Launch4";
      command="fan-speed-toggle zero";
      name="Zero fan speed";
    };

  };  
}
