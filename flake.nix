{ ############################ Initial scope ###################################

description = ''
  SputNix flake!
'';

inputs = {

  #====<< Core Nixpkgs >>======================================================>
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  home-manager.url = "github:nix-community/home-manager";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";

  disko.url = "github:nix-community/disko";
  disko.inputs.nixpkgs.follows = "nixpkgs";

  sops-nix.url = "github:Mic92/sops-nix";
  sops-nix.inputs.nixpkgs.follows = "nixpkgs";

  #====<< DEs & Compositors >>=================================================>
  niri.url = "github:sodiboo/niri-flake";
  niri.inputs.nixpkgs.follows = "nixpkgs";

};

outputs = { self, nixpkgs, niri, ... }@inputs:

let
  pa = {
    hostname    = "y720";
    system-path = "/etc/nixos";
  };
  umport = (import ./lib/umport.nix {inherit (nixpkgs) lib;}).umport;
  makeUsers = (import ./lib/makeusers.nix {inherit (nixpkgs) lib;}).makeUsers;
  recursiveMerge = (import ./lib/recursiveMerge.nix {inherit (nixpkgs) lib;}).recursiveMerge;
in

{ ############################ Output scope ####################################

  /* These are example configurations provided to begin using flakes.
  Rename each configuration to the hostnanme of the hardware each uses */ 
  nixosConfigurations = {

   #==<< Template configuration >>=============================================>
    y720 = nixpkgs.lib.nixosSystem {
      modules = [ ./configs/common.nix ];
      specialArgs = {
        inherit inputs pa umport makeUsers recursiveMerge niri ;};};
        
/*
   #==<< Template configuration >>=============================================>
    y720niri = nixpkgs.lib.nixosSystem {
      modules = [
        ./configs/default.nix 
        ./hardware/y720/hardware.nix
        #inputs.agenix.nixosModule.default
        ] ++ 
        umport { path = ./modules/essentials; recursive = true; };
      specialArgs = {
        #adminusers = builtins.catAttrs "hver" allusers;
        adminusers = allusers;
        hostname = "y720";
        inherit inputs system-path niri umport ;};};

   #==<< Template configuration >>=============================================>
    template = nixpkgs.lib.nixosSystem {
      modules = [
        ./configs/template.nix 
        ./hardware/template/hardware.nix
        #inputs.agenix.nixosModule.default
        ] ++ 
        umport { path = ./modules/essentials; recursive = true; };
      specialArgs = {
        #adminusers = builtins.catAttrs "hver" allusers;
        adminusers = allusers;
        hostname = "nixos";
        inherit inputs system-path umport ;};};
*/
    # Using the following command, a result directory will be made
    # with a custom ISO in the 'result/bin' directory.
    # $ nix build \.#nixosConfigurations.ISO.config.system.build.isoImage
    # put your packages you want on the ISO in ./configd/ISO-image.nix
   #==<< Custom ISO image >>===================================================>
    ISO = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./configs/ISO-image.nix
        inputs.home-manager.nixosModules.default ]; };

  };
/*
  devShells.system = {
    "<name>" = derivation;
  }
*/
};} ################ End of Output and inital scope ############################
