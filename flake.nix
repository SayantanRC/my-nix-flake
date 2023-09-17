# cd /mnt/linux_shared/my_nix_flake
# nixos-rebuild build --impure --flake .#srcnix
# sudo nixos-rebuild switch --impure --flake .#srcnix

{
  description = "My GNOME Nix config";
  
  inputs = {
    nixpkgs = { 
      url = "github:NixOS/nixpkgs/release-23.05";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };
  in
  {
    nixosConfigurations.srcnix = nixpkgs.lib.nixosSystem {
      inherit system;
      modules =
      [
        /etc/nixos/configuration.nix
        ./my_mount_points.nix
        ./my_general_configs.nix
        ./my_gnome_configs.nix
        ./my_dev_stuff.nix
      ];
    };
  };
}
