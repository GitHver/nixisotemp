{ ############################ Initial scope ###################################

description = "SputNix flake!";

inputs = {

  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  home-manager.url = "github:nix-community/home-manager";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";

  disko.url = "github:nix-community/disko";
  disko.inputs.nixpkgs.follows = "nixpkgs";

  niri.url = "github:sodiboo/niri-flake";

};

outputs = { self, nixpkgs, niri, ... }@inputs:

let
  allusers = import ./users.nix;
  system-path      = "/etc/nixos";
  umport = (import ./modules/lib/umport.nix {inherit (nixpkgs) lib;}).umport;
in

{ ############################ Variable scope ##################################

  /* These are example configurations provided to begin using flakes.
  Rename each configuration to the hostnanme of the hardware each uses */ 
  nixosConfigurations = {

   #==<< Template configuration >>=============================================>
    template = nixpkgs.lib.nixosSystem {
      modules = [ ./configs/default.nix ./hardware/template/hardware.nix ] ++ 
      umport { path = ./modules/essentials; recursive = true; };
      specialArgs = {
        #adminusers = builtins.catAttrs "hver" allusers;
        adminusers = allusers;
        hostname = "y720";
        inherit inputs system-path umport ;};};

    # Using the following command, a result directory will be made
    # with a custom ISO in the 'result/bin' directory.
    # $ nix build \.#nixosConfigurations.ISO.config.system.build.isoImage
    # put your packages you want on the ISO in ./configd/ISO-image.nix
   #==<< Custom ISO image >>===================================================>
    ISO = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [ ./configs/ISO-image.nix ]; };

  };
/*
  devShells.system = {
    "<name>" = derivation;
  }
*/
};} ################ End of variable and inital scope ##########################
