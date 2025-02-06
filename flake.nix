{ ############################ Initial scope ###################################

  # Replace this with a description of what your flake does
  description = ''
    # The SputNix flake!

    The Purpose this flake is to be a starting template for beginners to use
    in order to get familiar with the Nix ecosystem. It is not a complete
    framework for using your system like a distribution, but is designed in
    a way for you to be easily able to modify by taking a fairly unopinionated
    stance on structuring.
  '';

  inputs = {
    #====<< Core Nixpkgs >>====================================================>
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #====<< Extension utils >>=================================================>
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixisoextras.url = "github:GitHver/nixisoextras";
    nixisoextras.inputs.nixpkgs.follows = "nixpkgs";
    #====<< Cosmic Desktop >>==================================================>
    cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    cosmic.inputs.nixpkgs.follows = "nixpkgs";
    #====<< Other >>===========================================================>
    xremap.url = "github:xremap/nix-flake";
    xremap.inputs.nixpkgs.follows = "nixpkgs";
  };

  #====<< Outputs Field >>=====================================================>
  outputs = { self, nixpkgs, ... } @ inputs: let
    #====<< Required variables >>======>
    lib = nixpkgs.lib // inputs.nixisoextras.lib;
    #====<< Used functions >>==========>
    # inherit (builtins) attrNames readDir;
    inherit (lib) nixosSystem namesOfDirsIn genAttrs attrsFromList;
    inherit (lib.lists) flatten forEach;
    inherit (lib.filesystem) listFilesRecursive;
    #====<< Host information >>========>
    hostnames = namesOfDirsIn ./hosts;
    # hosts = forEach hostnames (host: import ./hosts/${host}/info.nix);
    # This is only for the formatter, as it is not tied to an already active system.
    genForAllSystems = (funct: genAttrs supportedSystems funct);
    supportedSystems = [
      "x86_64-linux"
      # "aarch64-linux"
    ];
  in {

    #====<< Nix Code Formatter >>==============================================>
    # This defines the formatter that is used when you run `nix fmt`. Since this
    # calls the formatters package, you'll need to define which architecture
    # package is used so different computers can fetch the right package.
    formatter = genForAllSystems (system:
      let pkgs = import nixpkgs { inherit system; };
      in pkgs.nixpkgs-fmt
      or pkgs.nixfmt-rfc-style
      or pkgs.alejandra
    );

    #====<< NixOS Configurations >>============================================>
    # Here are all your different configurations. The function below takes a
    # list of all the hostnames for your hosts (determined by the names of the
    # directories in the `/hosts` directory) and creates an attribute set for
    # each host in the list.
    nixosConfigurations = attrsFromList (forEach hostnames (host: {
      "${host}" = nixosSystem {
        specialArgs = { inherit lib inputs host; };
        modules = flatten [
          ./hosts/${host}
          self.nixosModules.full
          { nixpkgs.overlays = flatten [ self.overlays.inputOverlays ]; }
        ];
      };
    }));

    #====<< NixOS Modules >>===================================================>
    # This creates an attributeset where the default attribute is a list of
    # all paths to modules. This can then be referenced with the `self`
    # attribute to give you access to all your modules anwhere.
    nixosModules = rec {
      default = { imports = listFilesRecursive ./modules; };
      full = [ default ] ++ inputModules;
      inputModules = (with inputs; [
        disko.nixosModules.default
        cosmic.nixosModules.default
        xremap.nixosModules.default
      ]);
    };

    #====<< Overlays >>========================================================>
    # Overlays are perhaps the most powerful feature Nix has. You can use them
    # to overlay overrides to existing packages in the with custom options. This
    # alloes you to apply your own patches or build flags with out needing to
    # maintain a fork of nixpkgs or adding a third party repository.
    overlays = {
      inputOverlays = (with inputs; [
        nixisoextras.overlays.default
      ]);
      # someOtherOverlay = overlay;
    };

  }; ############### The end of the `outputs` scope ############################

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cosmic.cachix.org/"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
    ];
  };

} ################## End of the inital scope ###################################
