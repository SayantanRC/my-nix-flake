{ config, lib, pkgs, modulesPath, username, ... }:

let

  fan-toggle = pkgs.writeShellScriptBin "fan-speed-toggle" ''
    current_profile=$(asusctl profile -p | awk '{print $NF}')

    max_beginning=`asusctl fan-curve -g | head -n 1 | awk -F',' '{print $2}' | grep ":100%"`
    zero_ending=`asusctl fan-curve -g | head -n 1 | awk -F',' '{print $9}' | grep ":0%"`

    # Max speed : max -> default
    if [[ -n $max_beginning && "$1" != "max" ]]; then
      asusctl fan-curve -d
      echo "Fans default speed."
      notify-send -a "Fan toggle" "Fans default speed"
      exit
    fi

    # Zero speed : zero -> default
    if [[ -n $zero_ending && "$1" != "max" ]]; then
      asusctl fan-curve -d
      echo "Fans default speed."
      notify-send -a "Fan toggle" "Fans default speed"
      exit
    fi

    # Asked for zero speed?
    if [[ "$1" == "zero" ]]; then
      asusctl fan-curve -m $current_profile -f cpu -D 30c:0%,49c:0%,59c:0%,69c:0%,79c:0%,89c:0%,99c:0%,109c:0%
      asusctl fan-curve -m $current_profile -f gpu -D 30c:0%,49c:0%,59c:0%,69c:0%,79c:0%,89c:0%,99c:0%,109c:0%
      asusctl fan-curve -e true -m $current_profile
      echo "Fans zero speed!"
      notify-send -a "Fan toggle" -u critical "Fans zero speed!!!!"
      exit
    fi

    # Neither max speed nor zero speed means default speed : default -> max
    asusctl fan-curve -m $current_profile -f cpu -D 30c:100%,49c:100%,59c:100%,69c:100%,79c:100%,89c:100%,99c:100%,109c:100%
    asusctl fan-curve -m $current_profile -f gpu -D 30c:100%,49c:100%,59c:100%,69c:100%,79c:100%,89c:100%,99c:100%,109c:100%
    asusctl fan-curve -e true -m $current_profile
    echo "Fans MAX speed!"
    notify-send -a "Fan toggle" "Fans MAX speed!"
  '';

  cpu-power-toggle = pkgs.writeShellScriptBin "cpu-power-toggle" ''

    state_file=/tmp/power_state

    if [[ ! -e $state_file ]]; then
      sudo runuser -u ${username} -- echo "low" > $state_file
    elif [[ "$1" == "maintain" ]]; then
      echo "Maintain CPU power."
    elif [[ `cat $state_file` != "low" || "$1" == "low" ]]; then
      sudo runuser -u ${username} -- echo "low" > $state_file
    elif [[ `cat $state_file` == "low" || "$1" == "default" ]]; then
      sudo runuser -u ${username} -- echo "default" > $state_file
    fi

    if [[ "$1" == "extreme" ]]; then
      sudo ryzenadj --stapm-limit=55000 --fast-limit=65000 --slow-limit=60000 --tctl-temp=90 --apu-skin-temp=90
      sudo runuser -u ${username} -- echo "extreme" > $state_file
      [[ "$*" != *"q"* ]] && notify-send -a "CPU power toggle" -u critical "!!!!EXTREME CPU POWER!!!!"
    elif [[ `cat $state_file` == "low" ]]; then
      sudo ryzenadj --stapm-limit=15000 --fast-limit=25000 --slow-limit=20000 --tctl-temp=65 --apu-skin-temp=45
      [[ "$*" != *"q"* ]] && notify-send -a "CPU power toggle" "Low CPU power"
    else
      sudo ryzenadj --stapm-limit=35000 --fast-limit=55000 --slow-limit=50000 --tctl-temp=75 --apu-skin-temp=70
      [[ "$*" != *"q"* ]] && notify-send -a "CPU power toggle" "HIGH CPU power!!"
    fi

  '';

  extreme-perf = pkgs.writeShellScriptBin "extreme-perf" ''
    fan-speed-toggle max
    sleep 1
    cpu-power-toggle extreme
  '';

  fan-toggle-maintain-cpu-power = pkgs.writeShellScriptBin "fan-toggle-maintain-cpu-power" ''
    fan-speed-toggle $1
    sleep 1
    cpu-power-toggle maintain q
  '';

in
{
  
  # Various links:
  # https://github.com/Quoteme/nixos/blob/nixos_23.05/hardware/asusROGFlowX13.nix
  # https://github.com/camillemndn/nixos-config/blob/main/hardware/asus/gv301qe/default.nix

  # get newest kernel
  #boot.kernelPackages = pkgs.linuxPackages_latest;
  # using 6.5 as per this post:
  # https://pay.reddit.com/r/NixOS/comments/17lcp1j/nixos_update_on_unstable_stopping_on_nvidia_driver/
  boot.kernelPackages = pkgs.linuxPackages_6_5;
  
  # https://github.com/Quoteme/nixos/blob/nixos_23.05/hardware/asusROGFlowX13.nix
  # https://github.com/camillemndn/nixos-config/blob/f71c2b099bec17ceb8a894f099791447deac70bf/hardware/asus/gv301qe/default.nix#L46
  boot.kernelPatches = [{
    name = "asus-rog-flow-x13-tablet-mode";
    patch = builtins.fetchurl {
      # url = "https://gitlab.com/asus-linux/fedora-kernel/-/raw/rog-6.5/0001-HID-amd_sfh-Add-support-ior-tablet-mode-switch-senso.patch";
      # sha256 = "sha256:08qw7qq88dy96jxa0f4x33gj2nb4qxa6fh2f25lcl8bgmk00k7l2";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-HID-amd_sfh-Add-support-for-tablet-mode-switch-senso.patch?h=linux-flowx13";
      sha256 = "sha256:1s1zyav5sz5k01av0biwkwl4x20qggj9k27znryz58khdblwxf4j";
    };
  }];
  
  environment.systemPackages = with pkgs; [
    amdgpu_top
    unstable.asusctl
    unstable.supergfxctl
    ryzenadj
    cpufrequtils

    # scripts
    fan-toggle
    cpu-power-toggle
    extreme-perf
    fan-toggle-maintain-cpu-power
  ];

  # asus-linux
  services.supergfxd = {
    enable = true;
    settings = {
      vfio_enable = true;
      vfio_save = false;
      always_reboot = false;
      no_logind = false;
      logout_timeout_s = 30;
      hotplug_type = "Asus";
    };
  };

  # Forcing asusd to use new asusctl.
  # First line of ExecStart clears existing value: https://github.com/NixOS/nixpkgs/issues/63703#issuecomment-504836857
  systemd.services = {
    asusd = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.unstable.asusctl}/bin/asusd"
        ];
      };
    };
    supergfxd = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.unstable.supergfxctl}/bin/supergfxd"
        ];
      };
    };
  };

  systemd.services.supergfxd.path = [ pkgs.kmod pkgs.pciutils ];

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
      offload.enable = true;
      offload.enableOffloadCmd = true;
      amdgpuBusId = "PCI:8:0:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  
  hardware = {
    sensor.iio.enable = true;
    enableRedistributableFirmware = true;
  };
  
  # commenting it out because we will run Steam from flatpak.
  # Install Flatseal and open entry for Steam.
  # Add this under "Environment": STEAM_FORCE_DESKTOPUI_SCALING=3.0
  # In addition to this, under "Filesystem" -> "Other files"
  # add "/mnt/linux_shared/steam_lib" (without quotes).
  # Now open Steam. Under Steam -> Settings -> Storage,
  # click on dropdown -> Add drive -> choose the location.
  #
  #environment.sessionVariables = {
  #  STEAM_FORCE_DESKTOPUI_SCALING = "3";
  #};

  # make the entries bigger than ant-size text.
  boot.loader.systemd-boot.consoleMode = "1";

  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "/run/current-system/sw/bin/ryzenadj";
          options = [ "NOPASSWD" ];
        }
        {
          command = "/run/current-system/sw/bin/runuser";
          options = [ "NOPASSWD" ];
        }
      ];
      groups = [ "wheel" ];
    }];
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "@reboot        root    sleep 5 && cpu-power-toggle low"
      "*/1 * * * *    root    cpu-power-toggle maintain q"
    ];
  };

}