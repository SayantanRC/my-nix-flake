{ config, pkgs, ... }: 
{
  home.packages = with pkgs; [
    mpv
    gthumb
    google-chrome
    qbittorrent
    localsend
    onboard
    android-tools
    # For flatpak
    gnome.gnome-software
  ];
  
  # https://nix-community.github.io/home-manager/options.html#opt-services.flameshot.settings
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon=true;
        showStartupLaunchMessage = false;
        contrastOpacity=102;
        drawColor="#ff0000";
        showHelp=false;
      };
    };
  };
}
