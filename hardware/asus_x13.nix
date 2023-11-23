# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a8e14eda-165e-48f2-8bd0-d281f5995de6";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/86E3-0F50";
      fsType = "vfat";
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp6s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # get newest kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  # using 6.5 as per this post:
  # https://pay.reddit.com/r/NixOS/comments/17lcp1j/nixos_update_on_unstable_stopping_on_nvidia_driver/
  #boot.kernelPackages = pkgs.linuxPackages_6_5;
  
  # https://github.com/Quoteme/nixos/blob/nixos_23.05/hardware/asusROGFlowX13.nix
  # https://github.com/camillemndn/nixos-config/blob/f71c2b099bec17ceb8a894f099791447deac70bf/hardware/asus/gv301qe/default.nix#L46
  #boot.kernelPatches = [{
  #  name = "asus-rog-flow-x13-tablet-mode";
  #  patch = builtins.fetchurl {
  #    # url = "https://gitlab.com/asus-linux/fedora-kernel/-/raw/rog-6.5/0001-HID-amd_sfh-Add-support-ior-tablet-mode-switch-senso.patch";
  #    # sha256 = "sha256:08qw7qq88dy96jxa0f4x33gj2nb4qxa6fh2f25lcl8bgmk00k7l2";
  #    url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-HID-amd_sfh-Add-support-for-tablet-mode-switch-senso.patch?h=linux-flowx13";
  #    sha256 = "sha256:1s1zyav5sz5k01av0biwkwl4x20qggj9k27znryz58khdblwxf4j";
  #  };
  #}];

  # asus-linux
  services.supergfxd.enable = true;

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };
  
  programs.rog-control-center.enable = true;
  programs.rog-control-center.autoStart = true;
  
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    modesetting.enable = true;

    powerManagement.enable = false;
    powerManagement.finegrained = false;

    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
    
    prime = {
      amdgpuBusId = "PCI:8:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  
  hardware = {
    sensor.iio.enable = true;
    enableRedistributableFirmware = true;
  };
  
  environment.systemPackages = with pkgs; [
    amdgpu_top
  ];
  
  # commenting it out because we will run Steam from flatpak.
  # Add this to flatseal: STEAM_FORCE_DESKTOPUI_SCALING=3.0
  #environment.sessionVariables = {
  #  STEAM_FORCE_DESKTOPUI_SCALING = "3";
  #};
}
