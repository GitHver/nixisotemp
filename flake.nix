{ ############################ Initial scope ###################################

  description = ''
    SputNix flake!
  '';

  nixConfig = {
    extra-substituters = [
      /**/"https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org/"
      "https://niri.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  inputs = {
    #====<< Core Nixpkgs >>====================================================>
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    #====<< Extension utils >>=================================================>
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    #====<< DEs & Compositors >>===============================================>
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";

    #====<< Libraries and utilities >>=========================================>
    nypkgs.url = "github:yunfachi/nypkgs";
    nypkgs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs: let
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    patt = {
      system-path = "/etc/nixos";
      pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};
    };
    plib = {
      makeUsers = (import ./library/makeusers.nix {
        inherit (nixpkgs) lib;
      }).makeUsers;
      recursiveMerge = (import ./library/recursiveMerge.nix {
        inherit (nixpkgs) lib;
      }).recursiveMerge;
    };
    lib = nixpkgs.lib;
    ylib = inputs.nypkgs.lib.${system};
    alib = lib // ylib // plib;
  in {

    /* These are example configurations provided to begin using flakes.
    Rename each configuration to the hostnanme of the hardware each uses */
    nixosConfigurations = {

      #==<< Desktop configuration >>===========================================>
      your-hostname = let hostname = "your-hostname"; in lib.nixosSystem {
        modules = [ ./hardware/${hostname}/hardware.nix ];
        specialArgs = { inherit inputs patt alib hostname; };
      };

      # Using the following command, a result directory will be made
      # with a custom ISO in the 'result/iso' directory.
      # $ nix build \.#nixosConfigurations.ISO.config.system.build.isoImage
      # put your packages you want on the ISO in `hardware/!configs/ISO-image.nix`
      #==<< Custom ISO image >>================================================>
      ISO = lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hardware/ISO-image.nix ];
      };

    };
    /*
      devShells.system = {
      "<name>" = derivation;
      }
    */
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

};} ################ End of Output and inital scope ##############################
