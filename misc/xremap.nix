{ config, lib, pkgs, inputs, username, ... }:
{

  imports = [
    inputs.xremap-flake.nixosModules.default
  ];
  
  services.xremap = {
    userName = "${username}";
    yamlConfig = ''
    keymap:
      - name: Global
        remap:
          RightAlt-RightBrace: End
          RightAlt-LeftBrace: Home
          RightShift-LeftBrace: Shift-Home
          RightShift-RightBrace: Shift-End
          Shift-Win-S: Shift-Print
    '';
  };
}
