{ config, pkgs, username, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    git-lfs
    meld
    python311
    python311Packages.pip
    python2
    sqlitebrowser
    cmakeWithGui
    bruno
    keystore-explorer
    jq
    envsubst
    gitlab-runner
    
    # raspberry pi
    rpi-imager
  ];

  # start ssh
  # https://discourse.nixos.org/t/ssh-agent-not-starting/16858
  programs.ssh.startAgent = true;

  environment.sessionVariables = {
    JAVA_HOME = "/home/${username}/android-studio/jbr";
  };
}
