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
    # nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    # nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";

    # niri.url = "github:sodiboo/niri-flake";
    # niri.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, ... }@inputs:

  let
    inherit (self) outputs;
    system = "x86_64-linux";
    # pkgs = nixpkgs.legacyPackages.${system};
    patt = {
      system-path = "/etc/nixos";
      pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};
      language   = "en_GB";
      formatting = "is_IS";
      timezone   = "Atlantic/Reykjavik";
      keyboard   = "is";
    };
    plib = {
      makeUsers = (import ./library/makeusers.nix {
        inherit (nixpkgs) lib;
      }).makeUsers;
    };
    lib = nixpkgs.lib // plib;
    template = (host: nixpkgs.lib.nixosSystem {
      modules = [ ./hardware/${host}/hardware.nix ] ++ outputs.nixosModules.default;
      specialArgs = {
        hostname = host;
        inherit inputs patt lib;
      };
    });
  in {

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

    nixosModules.default = lib.filesystem.listFilesRecursive ./modules;

    nixosConfigurations = {
      /* These are example configurations provided to begin using flakes.
      Rename each configuration to the hostnanme of the hardware each uses */

      # forEach hosts (host: host = (template host));

      #==<< Desktop configuration >>===========================================>
      your-hostname = let hostname = "your-hostname"; in
        nixpkgs.lib.nixosSystem {
          modules = [ ./hardware/${hostname}/hardware.nix ]
          ++ outputs.nixosModules.default;
          specialArgs = { inherit inputs patt lib hostname; };
        };

      # Using the following command, a result directory will be made
      # with a custom ISO in the 'result/iso' directory.
      # $ nix build \.#nixosConfigurations.ISO.config.system.build.isoImage
      # put your packages you want on the ISO in `hardware/!configs/ISO-image.nix`
      #==<< Custom ISO image >>================================================>
      ISO = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [ ./hardware/ISO-image.nix ];
      };

/*

  hardwareDirList = readDir ./hardware;
  Hosts = removeAttrs hardwareDirList [ "!template" ] ++ [ "ISO" ];

  filter (hasSuffix "hardware.nix" (toString paths)) 

  listOfAllPaths

  template = host: nixpkgs.lib.nixosSystem {
    modules = [ ./hardware/${host}/hardware.nix ] ++ outputs.nixosModules.default;
    specialArgs = {
      hostname = host;
      inherit inputs patt lib;
    };
  };

  listToAttrs (forEach hosts (host: nameValuePair host (config host)));

*/


    };
    /*
      devShells.system = {
      "<name>" = derivation;
      }
    */
  };
} ################ End of Output and inital scope ##############################
      # recursiveMerge = (import ./library/recursiveMerge.nix {
      #   inherit (nixpkgs) lib;
      # }).recursiveMerge;
