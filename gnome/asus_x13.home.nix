{ config, lib, pkgs, username, ... }:

let

  fullfans = pkgs.writeShellScriptBin "fullfans-toggle" ''
    current_profile=$(asusctl profile -p | awk '{print $NF}')

    max_beginning=`asusctl fan-curve -g | head -n 1 | awk -F',' '{print $2}' | grep ":100%"`
    zero_ending=`asusctl fan-curve -g | head -n 1 | awk -F',' '{print $9}' | grep ":0%"`

    # Max speed : max -> zero
    if [[ -n $max_beginning ]]; then
      asusctl fan-curve -m $current_profile -f cpu -D 30c:0%,49c:0%,59c:0%,69c:0%,79c:0%,89c:0%,99c:0%,109c:0%
      asusctl fan-curve -m $current_profile -f gpu -D 30c:0%,49c:0%,59c:0%,69c:0%,79c:0%,89c:0%,99c:0%,109c:0%
      asusctl fan-curve -e true -m $current_profile
      echo "Fans zero speed!"
      notify-send -a "Fan toggle" -u critical "Fans zero speed!"
      exit
    fi

    # Zero speed : zero -> default
    if [[ -n $zero_ending ]]; then
      asusctl fan-curve -d
      echo "Fans default speed."
      notify-send -a "Fan toggle" "Fans default speed"
      exit
    fi

    # Neither max speed nor zero speed means default speed : default -> max
    asusctl fan-curve -m $current_profile -f cpu -D 30c:100%,49c:100%,59c:100%,69c:100%,79c:100%,89c:100%,99c:100%,109c:100%
    asusctl fan-curve -m $current_profile -f gpu -D 30c:100%,49c:100%,59c:100%,69c:100%,79c:100%,89c:100%,99c:100%,109c:100%
    asusctl fan-curve -e true -m $current_profile
    echo "Fans MAX speed!"
    notify-send -a "Fan toggle" "Fans MAX speed!"
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
