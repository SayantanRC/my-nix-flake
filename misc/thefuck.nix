{ config, pkgs, username, home-manager, ... }:

{
  environment.systemPackages = with pkgs; [
    thefuck
  ];
  environment.interactiveShellInit = ''
    eval $(thefuck --alias)
  '';

  home-manager.users.${username} = {
    home.file.".config/thefuck/settings.py" = {
      force = true;
      text = ''
        exclude_rules = [ "fix_file" ]
      '';
    };
  };
}