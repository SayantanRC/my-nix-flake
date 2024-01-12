{ config, pkgs, lib, ... }:
{

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  
  environment.systemPackages = with pkgs; [
    papirus-icon-theme
    gnome-extension-manager
    gjs
  ];
  
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-characters
  ]);
  
  # To query type: xdg-mime query filetype filename.ext
  # Another example: xdg-mime query default "image/*"
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "image/png" = [ "org.gnome.Loupe.desktop" ];
      "image/bmp" = [ "org.gnome.Loupe.desktop" ];
      "image/jpg" = [ "org.gnome.Loupe.desktop" ];
      "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
      "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
      "application/pdf" = [ "org.gnome.Evince.desktop" ];
    };
    removedAssociations = {
      "image/png" = [ "google-chrome.desktop" ];
      "image/bmp" = [ "google-chrome.desktop" ];
      "image/jpg" = [ "google-chrome.desktop" ];
      "image/jpeg" = [ "google-chrome.desktop" ];
    };
  };
  
  # =============== Enable GSConnect ===============
  # To use GSConnect, we need to enable some ports.
  # https://github.com/NixOS/nixpkgs/issues/116388
  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
    # Warpinator
    { from = 42000; to = 42001; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
    # Warpinator
    { from = 42000; to = 42001; }
  ];
  networking.firewall.allowedTCPPorts = [
    # localsend
    53317 
  ];
  networking.firewall.allowedUDPPorts = [
    # localsend
    53317 
  ];
  
  # GSettings schemas of all apps are not made global unless they are declared here.
  # Visible schemas paths can be seen by `echo $XDG_DATA_DIRS | tr ":" "\n"`
  # Add the apps whose schemas are to be made global in this block.
  # https://github.com/NixOS/nixpkgs/issues/33277#issuecomment-354714431
  services.xserver.desktopManager.gnome.extraGSettingsOverridePackages = with pkgs; [
    gnome.nautilus
    #gnome.mutter
    #gtk4
  ];

  services.xserver.desktopManager.gnome.extraGSettingsOverrides = ''
    
    # Examples
    #
    # [org.gnome.desktop.wm.keybindings]
    # switch-windows=['<alt>Tab']
    #
    # [org.gnome.shell.keybindings]
    # show-screenshot-ui= ['<Shift>Print']
    
  '';
}
