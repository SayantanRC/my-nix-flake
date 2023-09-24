{ config, pkgs, ... }:

{
  # Enable default wayland on plasma
  services.xserver.displayManager.defaultSession = "plasmawayland";

  # Add lightly theme
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
