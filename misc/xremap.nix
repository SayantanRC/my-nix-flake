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
          
      - name: Screenshots
        remap:
          Shift-Win-S:
            remap:
              Shift-Win-S: Print
              S: Print
              P: Shift-Print
    '';
  };
}
