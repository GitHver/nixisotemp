{ ############################ Initial scope ###################################

description = ''
  SputNix flake!
'';

inputs = {

  #====<< Core Nixpkgs >>======================================================>
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  stable.url  = "github:nixos/nixpkgs/nixos-24.05";

  # home-manager.url = "github:nix-community/home-manager";
  # home-manager.inputs.nixpkgs.follows = "nixpkgs";

  #====<< Extension utils >>===================================================>
  disko.url = "github:nix-community/disko";
  disko.inputs.nixpkgs.follows = "nixpkgs";

  sops-nix.url = "github:Mic92/sops-nix";
  sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  #====<< DEs & Compositors >>=================================================>
  nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";
  
  niri.url = "github:sodiboo/niri-flake";
  niri.inputs.nixpkgs.follows = "nixpkgs";

  hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  hyprland.inputs.nixpkgs.follows = "nixpkgs";

  #====<< Libraries and utilities >>===========================================>
  nypkgs.url = "github:yunfachi/nypkgs";
  nypkgs.inputs.nixpkgs.follows = "nixpkgs";

};

outputs = { self, nixpkgs, ... }@inputs:

let
  system = "x86_64-linux";
  patt = {
    system-path = "/etc/nixos";
  };
  plib = {
    makeUsers = (import ./library/makeusers.nix {
      inherit (nixpkgs) lib;
    } ).makeUsers;
    recursiveMerge = (import ./library/recursiveMerge.nix {
      inherit (nixpkgs) lib;
    } ).recursiveMerge;
  };
  lib = nixpkgs.lib;
  ylib = inputs.nypkgs.lib.${system};
  alib = lib // ylib // plib;
in {

  nixosConfigurations = {
  /* These are example configurations provided to begin using flakes.
  Rename each configuration to the hostnanme of the hardware each uses */ 

    #==<< Desktop configuration >>=============================================>
    YOUR_HOSTNAME = let hostname = "YOUR_HOSTNAME"; in
    nixpkgs.lib.nixosSystem {
      modules = [ ./hardware/${hostname}/hardware.nix ];
      specialArgs = { inherit inputs patt alib hostname; };
    };

    # Using the following command, a result directory will be made
    # with a custom ISO in the 'result/bin' directory.
    # $ nix build \.#nixosConfigurations.ISO.config.system.build.isoImage
    # put your packages you want on the ISO in ./configd/ISO-image.nix
    #==<< Custom ISO image >>==================================================>
    ISO = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./hardware/${"!"}configs/ISO-image.nix ];
    };

  };
/*
  devShells.system = {
    "<name>" = derivation;
  }
*/
};} ################ End of Output and inital scope ############################
