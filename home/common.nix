{ config, pkgs, ... }: 

let

  # https://github.com/flameshot-org/flameshot/issues/3365#issuecomment-1817581463
  fixflameshot = pkgs.writeShellScriptBin "fixflameshot" ''
    env QT_QPA_PLATFORM=wayland flameshot "$@"
  '';

in {
  # https://the-empire.systems/nixos-gnome-settings-and-keyboard-shortcuts
  
  # https://forum.manjaro.org/t/please-help-all-files-in-home-name-immediately-appear-on-desktop/28173/2
  # https://wiki.archlinux.org/title/XDG_user_directories
  # https://github.com/NixOS/nixpkgs/issues/221604
  #home.file.".config/user-dirs.dirs" = {
  #  force = true;
  #  text = ''
  #    XDG_DESKTOP_DIR="$HOME/Desktop"
  #    XDG_DOCUMENTS_DIR="$HOME/Documents"
  #    XDG_DOWNLOAD_DIR="$HOME/Downloads"
  #    XDG_MUSIC_DIR="$HOME/Music"
  #    XDG_PICTURES_DIR="$HOME/Pictures"
  #    XDG_PUBLICSHARE_DIR="$HOME/Public"
  #    XDG_TEMPLATES_DIR="$HOME/Templates"
  #    XDG_VIDEOS_DIR="$HOME/Videos"
  #  '';
  #};

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
  };
  
  home.packages = with pkgs; [
    mpv
    gthumb
    google-chrome
    floorp
    qbittorrent
    localsend
    cinnamon.warpinator
    onboard
    android-tools
    sony-headphones-client
    unstable.overskride
    kooha
    # For flatpak
    gnome.gnome-software

    # scripts
    fixflameshot
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
