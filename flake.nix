# cd "/mnt/linux_shared/my_nix_flake"
# CONFIG=asus-gnome # example
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
    # Unstable setup inspired from: 
    # https://www.reddit.com/r/NixOS/comments/klbuu2/unstable_packages_in_configurationnix_using_flakes/
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    overlay-unstable = final: prev: {
      unstable = nixpkgs-unstable.legacyPackages.${system};
    };
    pkgs = import nixpkgs {
      inherit system;
      config = { 
        allowUnfree = true;
        permittedInsecurePackages = [
          "electron-12.2.3"
          "electron-19.1.9"
          "python-2.7.18.7"
        ];
      };
      overlays = [ overlay-unstable ];
    };
    username = "sayantan";
    stateVersion = "23.05";
  in
  {
    nixosConfigurations = {
    
    
      # ========================== HP ==========================
      
      # For my HP x360, with GNOME 44.2
      hp-gnome = nixpkgs.lib.nixosSystem {
      
        inherit system;
        specialArgs = { inherit username stateVersion pkgs inputs; };
        
        modules = [
        
         { networking.hostName = "hp-gnome"; }
          
          ./hardware/hp-x360.nix

          ./system/common.nix
          ./system/gnome.nix

          ./misc/my_mount_points.nix
          ./misc/my_dev_stuff.nix
          ./misc/xremap.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit username stateVersion inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              home.stateVersion = stateVersion;
              imports = [
                ./home/common.nix
                ./home/gnome.nix
                ./home/gnome.hp-x360.nix

                ./home/gnome.xremap.nix
              ];
            };
          }
        ];
      };
      
      hp-plasma = nixpkgs.lib.nixosSystem {
      
        inherit system;
        specialArgs = { inherit username stateVersion pkgs inputs; };
        
        modules = [
        
         { networking.hostName = "hp-plasma"; }
          
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
      
      hp-hyprland = nixpkgs.lib.nixosSystem {
      
        inherit system;
        specialArgs = { inherit username stateVersion pkgs inputs; };
        
        modules = [
        
         { networking.hostName = "hp-hyprland"; }
          
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
      asus-gnome = nixpkgs.lib.nixosSystem {
      
        inherit system;
        specialArgs = { inherit username stateVersion pkgs inputs; };
        
        modules = [
        
         { networking.hostName = "asus-gnome"; }
          
          ./hardware/asus-x13.nix

          ./system/asus-x13.nix
          ./system/common.nix
          ./system/gnome.nix

          ./misc/my_mount_points.nix
          ./misc/my_dev_stuff.nix
          ./misc/my_server.nix
          ./misc/xremap.nix
          #./misc/distrobox.nix
          #./misc/waydroid.nix
          ./misc/tailscale.nix
          ./misc/thefuck.nix
          
          home-manager.nixosModules.home-manager {
            home-manager.extraSpecialArgs = { inherit username stateVersion inputs; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = {
              home.stateVersion = stateVersion;
              imports = [
                ./home/common.nix
                ./home/gnome.nix
                ./home/gnome.asus-x13.nix

                ./home/gnome.xremap.nix
                ./home/gnome.tailscale.nix
                ./home/thefuck.nix
              ];
            };
          }
        ];
      };
      
    };
  };
}
