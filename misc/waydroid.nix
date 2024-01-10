{ config, pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];
  virtualisation.waydroid.enable = true;
  # sudo waydroid init -s GAPPS -f
  # sudo systemctl start waydroid-container
  #
  # For gplay registration, follow this: https://github.com/waydroid/waydroid/issues/379#issuecomment-1152526650
  # Or here: https://docs.waydro.id/faq/google-play-certification

  # edit /var/lib/waydroid/waydroid_base.prop
  # ro.hardware.gralloc=default
  # ro.hardware.egl=swiftshader
}