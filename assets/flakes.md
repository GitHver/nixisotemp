
# Flakes

If you have been using NixOS or used it before, you'll undoubtedly have heard people mention "flakes". In fact I have mentioned them a lot in the text leading up to this chapter. But what are flakes? The name isn't exactly descriptive and everyone seams to describe flakes in different ways? And why would you even want to use flakes?

### What do flakes even do?

Flakes in their most common usage are just version pinning for packages. They replace the `nix-channel` with a more declarative and integrated way of managing channels and other inputs. The `flake.lock` is created by the inputs in the `flake.nix` and this is used to find the exact version of the packages you want, ensuring full reproducibility.

Since version pinning is declared in the repository you can declare your entire system from a single repo. This also works extremely well with Git as it makes it so that you can easily rollback to previous states even if you deleted the generation as you can revert to the specific git commit and your system will fetch the exact packages listed in the archived `flake.lock` file.

Flakes also have other features, in fact they have quite a lot of features, maybe even to many. One thing they do is that they do not allow the use of any file that isn't being tracked by git, making sure that the configuration can be recreated with only the Git repository. But this means having certain files that contain host specific options that isn't tracked by git is no longer an option. But flakes provide a solution to that with another feature.

Flakes provide a way to create multiple predefined configurations with `nixosConfigurations` in the `outputs` function. This is an attribute set of names that correspond to different config files to control all your different devices.

This is essentially what flakes are; an *input-output* control scheme where you can version all your inputs and packages and manage all your different hosts, shells and packages. An example of a minimal operational flake for NixOS would be:

```nix
{
  description = ''
	My flake!
  '';
  inputs = {
    nixpkgs = {
	  type = "github";
	  owner = "NixOS";
	  repo = "nixpkgs";
	};
  };
  outputs = { nixpkgs }: {
    nixosConfigurations = {
      "your-hostname" = nixpkgs.lib.nixSystem {
        modules = [ ./configuration.nix ];
      };
    };
  };
}
```

But even the description is optional, and if you only have one input and one host, you can use nix's syntactic sugar to shorten it to:

```nix
{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  outputs = { nixpkgs }: {
    nixosConfigurations."your-hostname" = nixpkgs.lib.nixSystem {
      modules = [ ./configuration.nix ];
    };
  };
}
```

So those of you who have NixOS configurations not using flakes because they are often to robust to understand, you can just create a `flake.nix` and use this as the contents and **BOOM** you are now using flakes.

### Inputs

The `inputs` attribute set is what controls what goes into the `flake.lock`. The `.lock` file is what specifies what version your packages use. `inputs` can have any number attributes, but needs at least one `nixpkgs` to specify what version (branch) you want to use as the default for your packages.

```nix
{
  inputs = {
    #====<< Core Nixpkgs >>====================================================>
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    #====<< DEs & Compositors >>===============================================>
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
    nixos-cosmic.inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

`<input>.inputs.nixpkgs.follows` can be used to make the `nixpkgs` input of the flake you are referencing use the same commit as your `nixpkgs`. This way you don't have many different versions of your packages taking up space in your disk.

To access inputs in the configuration the `@inputs` argument is used in the `outputs` function like so:

```nix
outputs = { self, nixpkgs, ... } @ inputs:
```

With this we don't have to put each and every input into the argument set, but can instead just reference them in the `inputs` set. To use an example, many flakes provide a `nixosModules` output that imports a bunch of options for you to use, so to access them we would normally import them with just the name of the input + the module, but using the inputs argument we first have to append `intputs` to it like so:

```nix
{ pkgs, inputs, ... }:
{
  imports = [ inputs.<inputName>.nixosModules.default ];
}
```

Then by assigning `pkgs-stable` as `import imputs.nixpkgs-stable {inherit system;};`, we can then access stable packages as `pkgs-stable.<package>`.

### Outputs

Outputs are the Things that your flake provides. It can be anything, but there are conventions that specify what names to use and how to structure it. Take a look at the `outputs` variable as it is defined in the flake.nix:

```nix
outputs = { self, nixpkgs, ... } @ inputs:
```

you can see that `outputs` is a function that takes the arguments `self`, `nixpkgs` and then anything else through the `inputs` attribute set.

there is also a `let ... in` block that defines a couple of variables to be used inside the main scope of the function. The important part to see here is that we assign `outputs` as `self`. This makes it more clear what we are accessing as we can see that we access `outputs.<nameOfAttribuite>` from anywhere in the scope.

#### Outputs - `nixosConfigurations`

`nixosConfigurations` are used to generate and build your NixOS systems by using the `nix os` (`nixos-rebuild`) command. Scrolling down in the `flake.nix`, you should find this:

```nix
{
  nixosConfigurations = (genAttrs hostnames (host: nixosSystem {
    specialArgs = { inherit inputs lib host; };
    modules = flatten [
      (outputs.nixosModules.hostModules host)
      outputs.nixosModules.full
    ];
  })) #;
}
```

You can immediately see that this is a bit different from the minimal example used above. Lets focus on the first line first. `genAttrs` is a function that takes two arguments: a list of strings and a function, those being `hostnames` and `(host: nixosSytem {...})` respectively. The result is that each of the strings in the `hostnames` list are passed as arguments to the function that generates an attribute set and then creates an attribute with the name of the string. So if the `hostnames` list has `[ "john" "mike" ]` then it will generate the resulting set:

```nix
{
  nixosConfigurations = {
    "john" = nixosSystem {...}
    "mike" = nixosSystem {...}
  }
}
```

Each `{...}` contains the `specialArgs` and `modules` as is shown in the original function, but each `host` variable has been replaced with the respective name from `hostnames`. The `hostnames` list is generated by scanning the `hosts` directory and only taking the names of directories and putting them into strings. This way you just have to rename the directory containing you host to change the hostname, and you only need to add a directory to add a new host. No need to change anything in the flake.

`modules` has a `flatten` function attached to it as both the entries in it are list of paths/sets, and list aren't allowed, so flattening the list makes it into a single list. `specialArgs` is just an argument set passed to the modules.

Below all that you'll also find this:

```nix
// {
  ISO = nixosSystem {
    specialArgs = { inherit inputs lib; };
    modules = [ ./hosts/ISO-image.nix ];
  };
};
```

This uses the `//` operator to update the host attribute set generated from the `nixosConfigurations` function above with a single extra attribute called `ISO`. As the name suggest it is a template for an ISO image to flash into a USB drive to install NixOS. The contents of the image are defined in `hosts/ISO-image.nix` and currently is the configuration used to generate the image you used to install your system, but you can edit it's contents to make your own personal ISO installation image.

#### Outputs - `nixosModules`

Used by flakes (yours and others) in the `modules` list in `nixosConfigurations` and in `imports` in regular nix files.

```nix
{
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
}
```

Here you can see that `default` is just recursively importing all files in the `modules` directory. This way other users that reference this flake in their inputs can access your special modules with `inputs.your-flake.nixosModules.default`.

`inputModules` is the collection of all modules from flakes you reference. This is useful as you don't want to type out each flake module you use each time. This is separated from default as other users who use your flake modules likely won't want to import modules form flakes they might not be using.

You might have noticed the `rec` keyword attached to the set scope. This is short for *"recursive"* which means that attributes can reference each other. You can see this in action by how `full` is the combination of `default` and `inputModules`, and this way you can use `outputs.nixosModules.full` to import all the modules *you* use.

Lastly `hostModules` is a function that takes a single name (string) and interpolates it into a bunch of paths and returns those paths in a list. All the paths listed need to be present to make a full NixOS configuration.

#### Outputs - `lib`

This is a library of nix expressions to use and reuse. There is a few functions I have made that are available in the `library` directory. If you take a look at how it is defined you'll see this line:

```nix
{
  lib = import ./library { inherit lib; };
}
```

here it imports the `default.nix` in the `library` directory. As that file is a function that needs one argument (`lib`), we append a attribute set as an argument to the function with the `lib`as the only argument.

If you take a look at what `lib` is defined to be in the `let .. in` block, you'll see it's:

```nix
let lib = nixpkgs.lib // outputs.lib;
```

You can see that we assign 2 attribute sets as the lib variable by updating the first one with the second one with the `//` operator. The first set is the `nixpkgs` standard library, but the second one is our library we are defining in the first place. So the lib variable we pass to our library contains our library?

This is a neat feature of the Nix language called lazy evaluation. Nothing is computed until it is called/used, so when we need the `lib` variable when defining our library it takes the lib as it is defined and passes that to the function, which will work as our library is not dependent on itself, only the `nixpkgs` lib, so once we build our library, the `lib` variable is fully defined and available to other modules.

#### Outputs - `pkgs`, `devShells`, `overlays`

This part is currently work in progress. Thankfully you don't need any of these for a working system.

<!--
#### Outputs - `devShells`

Ephemeral environments to develop projects or debug package building. (This part is still work in progress).

`nix develop`

#### Outputs - `pkgs` & `apps`

Packages that a flake provides, used by `nix build` & Programs that can be run by `nix run`. Both require the architecture to be specified as these are binaries. (This part is still work in progress).

#### Outputs - `overlays`

Used to overlay package sets with custom attributes. (This part is still work in progress).
--->

#### Outputs - `formatter`

Used by `nix fmt` to uniformly format your code. You can choose from any of the formatters listed in the flake, but you can of course only use one at a time.

```nix
formatter = genForAllSystems (system: let
  pkgs = import nixpkgs { inherit system; };
in (with pkgs;    # Choose any of the formatters below. Only one!
  # nixpkgs-fmt       # The original nix formatter.
  # nixfmt-rfc-style  # The new Nix formatter. Still under development
  alejandra         # The uncompromising Nix code formatter
));
```

Note that this repository is not formatted with any formatter, but by hand. This is because I try to present everything in the most outsider friendly way, as this is your own personal repo, where you don't have to conform to conventions or work with others. Once you get more familiar with Nix, you should start using formatters and follow best practices.

#### Outputs - `anything`

You can actually define any value in the outputs function scope, the above are just conventions or things with special commands that access them (`nix build` with `pkgs`, etc). This means you can make anything and other flakes will be able to access them by calling the output by its name.

An example of this the `lib` output. If you check the nixos wiki you'll see no mention of a `lib` output, but you can create it non the less. You can even name it the full `library` and it will work all the same.

There are many more commonly used outputs such as `hydraJobs` to set up binary caches, but you don't need to know how to use those until that time comes.

### `nixConfig`

At the bottom of the flake you'll see a set called `nixConfig`. This allows you to specify cachix sustituters to used to build your flake and they are given a promt when building from them on whether you want trust them. This way users that reference your flake can be notified of extra substituters being used and decide for themselves if they want to trust them.

### Flake frameworks

There are many "frameworks" available for working with flakes. These can be very helpful, especially if it enforces uniformity when working with other people. There are many available, notably `flake-parts` and `flake-utils`.

These can result in less boiler plate, but for `nixosConfigurations`, these are a bit less useful and maybe even to complex for this usecase. If you eventually dive into packaging for Nix, you should give these a look as they can help a lot with managing projects.

### The experiment

As you might have noticed, 'Flakes' are and experimental feature and are subject to change. There are many criticism of the flake model and many features are in the works so just beware of that as not everything might be backwards compatible.

# Next

[Home-manager](./home-manager)