# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, username, stateVersion, ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # ports for applications
  networking.firewall.allowedTCPPorts = [
    # localsend
    53317
    # warpinator
    42000
    42001
  ];
  networking.firewall.allowedUDPPorts = [
    # localsend
    53317
    # warpinator
    5353
  ];

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = username;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox-bin
    ];
  };

  system.stateVersion = stateVersion; # Did you read the comment?
  
  # ================== more general configs ==================
  
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

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
  # https://www.reddit.com/r/NixOS/comments/16in2if/how_to_turn_on_bluetooth_experimental_features/
  systemd.services.bluetooth.serviceConfig.ExecStart = lib.mkForce [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf --experimental"
  ];

  # add gparted to already present system packages
  # https://stackoverflow.com/a/53692127
  environment.systemPackages = with pkgs; [
    # system tools
    dmidecode
    usbutils
    coreutils-full
    fuse
    tree
    exfatprogs
    p7zip
    unrar
    stress
    pv
    pciutils
    lshw
    libnotify
    smartmontools
    dig
    x265
    
    # nixos
    nixos-option
    steam-run
    appimage-run
    nix-tree
    
    # user programs
    neofetch
    vim
    gparted
    gedit
    gnome.dconf-editor
    etcher
    pavucontrol
    gsmartcontrol
    cpu-x
    telegram-desktop
  ];
  
  # May enable tap to click by default.
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad.tapping = true;
  
  # Flatpak: https://nixos.wiki/wiki/Flatpak
  services.flatpak.enable = true;
  
  # https://discourse.nixos.org/t/confusion-about-proper-way-to-setup-flathub/29806/12?u=line0174
  # https://fostips.com/remove-flatpak-repositories-linux/
  system.activationScripts = {
    flathub = ''
      /run/current-system/sw/bin/flatpak remote-add --system --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
  
  # List all packages in /etc/current-system-packages during rbuild.
  # https://www.reddit.com/r/NixOS/comments/fsummx/comment/fm45htj/?utm_source=share&utm_medium=web2x&context=3
  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in
    formatted;
  
  # Sudo exceptions
  # https://github.com/NixOS/nixpkgs/issues/58276
  security.sudo.extraConfig = ''
    ${username}	ALL=(root)	NOPASSWD: /run/current-system/sw/bin/nixos-rebuild
    ${username}	ALL=(root)	NOPASSWD: /run/current-system/sw/bin/nix-collect-garbage
  '';

  environment.variables = {
    EDITOR = "vim";
  };

}
