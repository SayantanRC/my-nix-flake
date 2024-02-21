{ config, lib, pkgs, username, ... }:
{
  home.file.".config/thefuck/settings.py" = {
    force = true;
    text = ''
      exclude_rules = [ "fix_file" ]
    '';
  };
}