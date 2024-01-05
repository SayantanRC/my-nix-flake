{ config, lib, pkgs, username, ... }:

let

  fullfans = pkgs.writeShellScriptBin "fullfans-toggle" ''
    current_profile=$(asusctl profile -p | awk '{print $NF}')

    if [[ -n `asusctl fan-curve -g | head -n 1 | awk -F',' '{print $2}' | grep "100%"` ]]; then
      asusctl fan-curve -d
      echo "Fans default speed."
      exit
    fi

    asusctl fan-curve -m $current_profile -f cpu -D 30c:100%,49c:100%,59c:100%,69c:100%,79c:100%,89c:100%,99c:100%,109c:100%
    asusctl fan-curve -m $current_profile -f gpu -D 30c:100%,49c:100%,59c:100%,69c:100%,79c:100%,89c:100%,99c:100%,109c:100%
    asusctl fan-curve -e true -m $current_profile
    echo "Fans MAX speed!"
  '';

in
{

  home.packages = with pkgs; [
    fullfans
  ];
  
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
      command="fullfans-toggle";
      name="Fan speed toggle";
    };

  };  
}
