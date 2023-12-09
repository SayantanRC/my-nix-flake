# cd "/mnt/linux_shared/my_nix_flake"
# CONFIG=hp_gnome # example
# nixos-rebuild build --flake .#$CONFIG
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
      url = "github:NixOS/nixpkgs/nixos-23.11";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = { 
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-12.2.3"
          "electron-19.1.9"
        ];
      };
    };
    username = "sayantan";
    stateVersion = "23.05";
  in
  {
    nixosConfigurations = {
    
    
      # ========================== HP ==========================
      
      # For my HP x360, with GNOME 44.2
      hp_gnome = nixpkgs.lib.nixosSystem {
      
        inherit system;
        specialArgs = { inherit username stateVersion pkgs inputs; };
        
        modules = [
          
          # ========== configs specific to HP x360 ==========
          ./hardware/hp_x360.nix
          ./misc/my_mount_points.nix
          # ====================
          
          ./general/configuration.nix
          ./gnome/configuration.nix
          
          ./misc/my_dev_stuff.nix
          
          ./xremap/configuration.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit username stateVersion inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              home.stateVersion = stateVersion;
              imports = [
               ./general/home.nix
               ./gnome/home.nix
               ./xremap/gnome.nix
              ];
            };
          }
        ];
      };
      
      hp_plasma = nixpkgs.lib.nixosSystem {
      
        inherit system;
        specialArgs = { inherit username stateVersion pkgs inputs; };
        
        modules = [
          
          # ========== configs specific to HP x360 ==========
          ./hardware/hp_x360.nix
          ./misc/my_mount_points.nix
          # ====================
          
          ./general/configuration.nix
          ./plasma/configuration.nix
          
          ./misc/my_dev_stuff.nix
          
          ./xremap/configuration.nix
        ];
      };
      
      hp_hyprland = nixpkgs.lib.nixosSystem {
      
        inherit system;
        specialArgs = { inherit username stateVersion pkgs inputs; };
        
        modules = [
          
          # ========== configs specific to HP x360 ==========
          ./hardware/hp_x360.nix
          ./misc/my_mount_points.nix
          # ====================
          
          ./general/configuration.nix
          ./hyprland/configuration.nix
          
          ./misc/my_dev_stuff.nix
          
          ./xremap/configuration.nix
        ];
      };
      
      
      
      
      
      
      # ========================== ASUS ==========================
      
      
      # For my ASUS X13, with GNOME 44.2
      asus_gnome = nixpkgs.lib.nixosSystem {
      
        inherit system;
        specialArgs = { inherit username stateVersion pkgs inputs; };
        
        modules = [
          
          ./hardware/asus_x13.nix
          ./misc/my_mount_points.nix
          
          ./general/configuration.nix
          ./gnome/configuration.nix
          
          ./misc/my_dev_stuff.nix
          
          ./xremap/configuration.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit username stateVersion inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              home.stateVersion = stateVersion;
              imports = [
               ./gnome/asus_x13.home.nix
               ./general/home.nix
               ./gnome/home.nix
               ./xremap/gnome.nix
              ];
            };
          }
        ];
      };
      
    };
  };
}
