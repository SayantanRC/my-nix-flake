{ config, pkgs, ... }:

{

  # Enable the Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  
  
  # Enable default wayland on plasma
  services.xserver.displayManager.defaultSession = "plasmawayland";

  environment.systemPackages = with pkgs; [
    lightly-qt
    libsForQt5.kalendar
    libsForQt5.kontact
    libsForQt5.kaccounts-providers
    libsForQt5.kaccounts-integration
    accountsservice
    libaccounts-glib
    kio-fuse
    libsForQt5.kio
    libsForQt5.kio-gdrive
  ];
}
