# cd "/mnt/linux_shared/my_nix_flake"
# CONFIG=hp_gnome # example
# nixos-rebuild build --impure --flake .#$CONFIG
# sudo nixos-rebuild switch --flake .#$CONFIG

# Resources
# https://www.tweag.io/blog/2020-07-31-nixos-flakes/
# https://www.youtube.com/watch?v=mJbQ--iBc1U&t=1094s
# https://github.com/novoid/nixos-config/blob/main/flake.nix
# https://discourse.nixos.org/t/flake-and-home-manager-20-11-configuration/20211/3
# https://www.youtube.com/watch?v=AGVXJ-TIv3Y

{
  description = "My GNOME Nix config";
  
  inputs = {
    nixpkgs = { 
      url = "github:NixOS/nixpkgs/release-23.05";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    pkgs = import nixpkgs {
      config = { 
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-12.2.3"
        ];
      };
    };
    username = "sayantan";
    stateVersion = "23.05";
  in
  {
    nixosConfigurations = {
      
      # For my HP x360, with GNOME 44.2
      hp_gnome = nixpkgs.lib.nixosSystem {
      
        system = "x86_64-linux";
        specialArgs = { inherit username stateVersion pkgs; };
        
        modules = [
          
          # ========== configs specific to HP x360 ==========
          ./hardware/hp_x360.nix
          ./misc/my_mount_points.nix
          # ====================
          
          ./general/configuration.nix
          ./gnome/configuration.nix
          
          ./misc/my_dev_stuff.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              home.stateVersion = stateVersion;
              imports = [
               ./general/home.nix
               ./gnome/home.nix
              ];
            };
          }
        ];
      };
      
      hp_plasma = nixpkgs.lib.nixosSystem {
      
        system = "x86_64-linux";
        specialArgs = { inherit username stateVersion pkgs; };
        
        modules = [
          
          # ========== configs specific to HP x360 ==========
          ./hardware/hp_x360.nix
          ./misc/my_mount_points.nix
          # ====================
          
          ./general/configuration.nix
          ./plasma/configuration.nix
          
          ./misc/my_dev_stuff.nix
        ];
      };
    };
  };
}
