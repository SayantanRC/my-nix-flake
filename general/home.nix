{ config, pkgs, ... }: 
{
  # https://the-empire.systems/nixos-gnome-settings-and-keyboard-shortcuts
  
  # https://forum.manjaro.org/t/please-help-all-files-in-home-name-immediately-appear-on-desktop/28173/2
  # https://wiki.archlinux.org/title/XDG_user_directories
  # https://github.com/NixOS/nixpkgs/issues/221604
  home.file.".config/user-dirs.dirs" = {
    text = ''
      XDG_DESKTOP_DIR="$HOME/Desktop"
      XDG_DOCUMENTS_DIR="$HOME/Documents"
      XDG_DOWNLOAD_DIR="$HOME/Downloads"
      XDG_MUSIC_DIR="$HOME/Music"
      XDG_PICTURES_DIR="$HOME/Pictures"
      XDG_PUBLICSHARE_DIR="$HOME/Public"
      XDG_TEMPLATES_DIR="$HOME/Templates"
      XDG_VIDEOS_DIR="$HOME/Videos"
    '';
  };
  
  home.packages = with pkgs; [
    mpv
    gthumb
    google-chrome
    qbittorrent
    localsend
    cinnamon.warpinator
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
