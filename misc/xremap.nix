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
            "RightAlt-Right" = "End";
            "RightAlt-Left" = "Home";
            "Shift-Win-S" = "Shift-Print";
          };
        }
      ];
    };
  };
}
