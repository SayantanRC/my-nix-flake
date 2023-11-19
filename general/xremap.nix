{ config, lib, pkgs, inputs, username, ... }:
{

  hardware.uinput.enable = true;
  users.groups.uinput.members = [ "${username}" ];
  users.groups.input.members = [ "${username}" ];

  imports = [
    inputs.xremap-flake.nixosModules.default
  ];
  
  services.xremap = {
    
  };
}
