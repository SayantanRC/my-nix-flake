{ config, pkgs, ... }:
let
  # https://the-empire.systems/nixos-gnome-settings-and-keyboard-shortcuts
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
in {

  # NTFS support: https://nixos.wiki/wiki/NTFS
  boot.supportedFilesystems = [ "ntfs" ];

  # Enable polkit. https://nixos.wiki/wiki/Polkit
  security.polkit.enable = true;

  # Enable mounting without password
  # https://nixos.wiki/wiki/Polkit#Reboot.2Fpoweroff_for_unprivileged_users
  # https://bbs.archlinux.org/viewtopic.php?pid=2004103#p2004103
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
            action.id == "org.freedesktop.udisks2.filesystem-fstab"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  # Fix theme in some apps. https://nixos.wiki/wiki/KDE#GTK_themes_are_not_applied_in_Wayland_applications
  programs.dconf.enable = true;

  # enable bluetooth: https://nixos.wiki/wiki/Bluetooth
  hardware.bluetooth.enable = true;

  # add gparted to already present system packages
  # https://stackoverflow.com/a/53692127
  environment.systemPackages = with pkgs; [
    # system tools
    dmidecode
    usbutils
    busybox
    fuse
    tree
    
    # nixos
    nixos-option
    steam-run
    appimage-run
    
    # user programs
    neofetch
    vim
    gparted
    gnome.dconf-editor
    etcher
  ];
  
  # May enable tap to click by default.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.tapping = true;
  
  # Flatpak: https://nixos.wiki/wiki/Flatpak
  services.flatpak.enable = true;
  
  # Required for etcher
  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
  ];
  
  users.users.sayantan.isNormalUser = true;
  
  imports = [ <home-manager/nixos> ];
  # https://discourse.nixos.org/t/starting-out-with-home-manager/31559
  #imports = [
  #  (import "${home-manager}/nixos")
  #];
  
  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.sayantan = { pkgs, ... }: {
      home = {
        stateVersion = "23.05";
        packages = with pkgs; [
          mpv
          gthumb
          bitwarden
          google-chrome
          qbittorrent
          localsend
          onboard
          android-tools
          # For flatpak
          gnome.gnome-software
        ];
        
      };
      
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
    };
  };
}
