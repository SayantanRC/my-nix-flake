{ config, lib, pkgs, inputs, username, ... }:
{

  imports = [
    inputs.xremap-flake.nixosModules.default
  ];
  
  services.xremap = {
    userName = "${username}";
    config = {
      keymap = [
        {
          name = "Global";
          remap = {
            "RightAlt-RightBrace" = "End";
            "RightAlt-LeftBrace" = "Home";
            "Shift-Win-S" = "Shift-Print";
          };
        }
      ];
    };
  };
}
