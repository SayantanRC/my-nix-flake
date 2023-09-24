{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    cinnamon.nemo-with-extensions
    papirus-icon-theme
    gnome-extension-manager
    gjs
  ];
  
  environment.gnome.excludePackages = (with pkgs; [
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    gnome-characters
  ]);
  
  # https://search.nixos.org/options?channel=23.05&show=xdg.mime.defaultApplications
  xdg.mime.defaultApplications = {
    "inode/directory" = "nemo.desktop";
  };
  
  # =============== Enable GSConnect ===============
  # To use GSConnect, we need to enable some ports.
  # https://github.com/NixOS/nixpkgs/issues/116388
  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
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
