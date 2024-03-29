{ config, lib, pkgs, inputs, username, ... }:
{

  imports = [
    inputs.xremap-flake.nixosModules.default
  ];
  
  services.xremap = {
    userName = "${username}";
    # enable watch: https://github.com/k0kubun/xremap/issues/371
    watch = true; # does not work anyway
    withGnome = true;
    serviceMode = "user";
    yamlConfig = ''
    keymap:
      - name: Home-End keys
        remap:
          RightAlt-Right: End
          RightAlt-Left: Home
          RightAlt-Up: PageUp
          RightAlt-Down: PageDown
          RightAlt-RightBrace: End
          RightAlt-LeftBrace: Home

      - name: Screenshots
        remap:
          Shift-Win-S: Shift-Print
          Shift-Alt-S: Print
      
      - name: Nautilus
        remap:
          Backspace: [LeftAlt-Left, Backspace]
        application:
          only: org.gnome.Nautilus
    '';
  };
  
  # Enable cron service to restart xremap on boot, because often times it fails to detect keyboard, even if watch is enabled.
  #services.cron = {
  #  enable = true;
  #  systemCronJobs = [
  #    "@reboot    root    sleep 5 && systemctl restart xremap.service"
  #  ];
  #};
}
