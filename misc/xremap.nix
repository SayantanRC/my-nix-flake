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
    modmap:
      - name: Remap right alt
        remap:
          RightAlt: RightMeta
    
    keymap:
      - name: Home-End keys
        remap:
          RightMeta-Right: End
          RightMeta-Left: Home
          RightMeta-Up: PageUp
          RightMeta-Down: PageDown
          RightMeta-RightBrace: End
          RightMeta-LeftBrace: Home

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
  
  # Disable touchpad while typing
  # https://www.reddit.com/r/NixOS/comments/yprnch/comment/ivs29dp/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
  # https://github.com/xremap/xremap/issues/152
  environment.etc."libinput/local-overrides.quirks".text = ''
    [xremap]
    MatchUdevType=keyboard
    AttrKeyboardIntegration=internal
  '';
  
  # Enable cron service to restart xremap on boot, because often times it fails to detect keyboard, even if watch is enabled.
  #services.cron = {
  #  enable = true;
  #  systemCronJobs = [
  #    "@reboot    root    sleep 5 && systemctl restart xremap.service"
  #  ];
  #};
}
