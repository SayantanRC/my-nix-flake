{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    meld
    python311
    python311Packages.pip
    #postman
    
    # raspberry pi
    rpi-imager
  ];

  # start ssh
  # https://discourse.nixos.org/t/ssh-agent-not-starting/16858
  programs.ssh.startAgent = true;
}
