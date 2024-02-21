{ config, pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    thefuck
  ];
  environment.interactiveShellInit = ''
    eval $(thefuck --alias)
  '';
}