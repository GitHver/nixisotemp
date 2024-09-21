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
    nixpkgs.url    = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-st.url = "github:nixos/nixpkgs/nixos-24.05";
    #====<< Extension utils >>=================================================>
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    #====<< Cosmic Desktop >>==================================================>
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";
  };

  #====<< Outputs Field >>=====================================================>
  outputs = inputs @ { self, nixpkgs, ... }: let
    #====<< Required arguments >>======>
    # Binds the outputs attribute set to a variable
    inherit (self) outputs;
    lib = nixpkgs.lib // outputs.lib;
    #====<< Used functions >>==========>
    inherit (lib) nixosSystem namesOfDirsIn genAttrs;
    inherit (lib.lists) flatten;
    inherit (lib.filesystem) listFilesRecursive;
    #====<< Host information >>========>
    hostnames = namesOfDirsIn ./hosts;
    genForAllSystems = (funct: genAttrs supportedSystems funct);
    supportedSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  in {

    #====<< Nix Code Formatter >>==============================================>
    /* This defines the formatter that is used when you run `nix fmt`. Since
    this calls the formatters package, you'll need to define which architecture
    package is used so different computers can fetch the right package. */
    formatter = genForAllSystems (system: let
      pkgs = import nixpkgs { inherit system; };
    in (with pkgs;    # Choose any of the formatters below. Only one!
      # nixpkgs-fmt       # The original nix formatter.
      # nixfmt-rfc-style  # The new Nix formatter. Still under development
      alejandra         # The uncompromising Nix code formatter
    ));

    #====<< Nix Expression Library >>==========================================>
    /* When programming in any language, you will want to avoid writing
    repetitive lines and definitions. Here you can define your own custom Nix
    library accessable to others who reference your flake. */
    lib = import ./library { inherit lib; };

    #====<< NixOS Configurations >>============================================>
    /* Here are all your different configurations. The function below takes a
    list of all the hostnames for your hosts (determined by the names of the
    directories in the `/hosts` directory) and creates an attribute set for
    each host in the list. */
    nixosConfigurations = (genAttrs hostnames (host: nixosSystem {
      specialArgs = { inherit inputs lib host; };
      modules = flatten [
        (outputs.nixosModules.hostModules host)
        outputs.nixosModules.full
      ];
    })) #;

    #====<< ISO image >>=======================================================>
    # Using the following command, a result directory will be made
    # with a custom ISO in the 'result/iso' directory.
    # $ nix build \.#nixosConfigurations.ISO.config.system.build.isoImage
    # put your packages you want on the ISO in the `hosts/ISO-image.nix` file
    // {
      ISO = nixosSystem {
        specialArgs = { inherit inputs lib; };
        modules = [ ./hosts/ISO-image.nix ];
      };
    };

    #====<< NixOS Modules >>===================================================>
    /* This creates an attributeset where the default attribute is a list of
    all paths to modules. This can then be referenced with the `outputs`
    attribute set to give you access to all your modules anwhere. */
    nixosModules = rec {
      default = { imports = listFilesRecursive ./modules; };
      inputModules = [
        inputs.disko.nixosModules.default
        inputs.nixos-cosmic.nixosModules.default
      ];
      full = [ default ] ++ inputModules;
      hostModules = (host: [
        ./hosts/${host}/hardware.nix
        ./hosts/${host}/accounts.nix
        ./hosts/${host}/disko.nix
        ./hosts/${host}/hardware-configuration.nix
      ]);
    };

    #====<< Nix Development Shells >>==========================================>
    /* Development shells `nix develop` are ephemeral environments where you
    can get access to packages that are only available in the initialized shell
    (like `nix shell`), but here you can go through execution stages manually to
    better test and verify packages. Packages from dev shells are also cached
    after initialization so that later calls are instant. */
    devShells = genForAllSystems (system: let
      pkgs = import nixpkgs { inherit system; }; 
    in {
      "helloShell" = import ./shells/helloShell.nix { inherit pkgs; };
      # "other" = import ./shells/otherShell.nix { inherit pkgs; };
    });

    #====<< Packages >>========================================================>
    /* Here is where you define your custom packages. You can package anything
    you want, but should only keep personal packages in this repository as it
    is better to keep papackages you want to be publicaly accessable in a
    seperate repository and eventually added to the offical nixpkgs repo. */
    # pkgs = supportedSystems (system:
    #   import ./pkgs system
    # );

    #====<< Applications >>====================================================>
    /* Applications differ from packages by that they can be started with:
    `nix run .#<name-of-application>`. As you can only "run" applications,
    other packages like theme sets or program extensions like plugins cannot
    be applications. Other than that they are identical. */
    # apps = supportedSystems (system:
    #   import ./apps system
    # );

    #====<< Overlays >>========================================================>
    /* Overlays are perhaps the most powerful feature Nix has. You can use them
    to overlay overrides to existing packages in the with custom options. This
    alloes you to apply your own patches or build flags with out needing to
    maintain a fork of nixpkgs or adding a third party repository. */
    # overlays = import ./overlays;

    #====<< Literally Anything >>==============================================>
    /* The ouputs set can contain anything you want, the above are just things
    mapped by the Nix command or just convention (which you should follow!),
    but if you need some thing else, you can just create an attribute for it. */
    anyName = "anything";

  };

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

} ################ End of Output and inital scope ##############################
