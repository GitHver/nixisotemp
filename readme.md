
# SputNix

Welcome to the Sput*Nix* Repository.

The aim of this repository is to provide a full feature NixOS configuration/flake, without it being

SputNix (this repository) is what you'd call a NixOS configuration/flake. It's a collection of configuration files all managed by the top-level `flake.nix`. It very closely resembles my personal repository, but has had some personal tastes/preferences and nested structures removed for ease of understanding. It's not a distribution derived from NixOS, but rather a starter template configuration for you to get up to speed with everything Nix has to offer as fast as possible, and exposing you to good practises in managing your system.

Getting this configuration to the point it is at took a lot of time, the reason being that the documentation for NixOS is not the best. The main problem with NixOS documentation isn't necessarily that it is bad, lacklustre or shallow (though it often can be), but rather that it is all scattered throughout the internet like a broken vase, and the ones you find often require 

This is why so many NixOS users may have such varied configurations, with some aspects of them being very clever, while simultaneously having some extremely questionable aspects, like tons of `if ... else` statements because the user hasn't heard about the config/options system, and just used the knowledge they had available to modularize their configuration.

This also results in many configurations being quite hard to navigate, making those GitHub pages newbies get linked to *use as reference* mostly useless as in order to use anything from someones configuration, you need to be able to untangle that one weird/over-complicated aspect that plaques everything, which often requires a lot of effort and know-how, which the newbies that stand to gain the most from it don't have.

So while robust, most configurations are built upon a very personal knowledge and learning journey, making the experience akin to those textbooks that leave the proof to the reader, "*as it is trivial to prove*" (it never is).

SputNix aims to be a one-stop shop for all the basics that you need in order to have a functional configuration at the start of your NixOS journey with all the features you would have otherwise found yourself rewriting your configuration in order to accommodate, like Flakes, Home-manager or Disko, while also explaining what these are, why you want them and how to modify them to your preference, instead of just blindly giving you a configuration with these features, reproducing the problems mentioned above.


# Configuration

With your system up and running you can start to get to know your system and it's inner workings. The workflow you will have to get familiar to is very similar to the installation process. It involves a lot of interacting with the terminal, but in time, you'll wonder how you ever used a computer with out it.

### Structure

If use `cd /ect/nixos` or `z /etc/nixos` you will go into the directory containing the configuration you modified during the installation. To see the directory in a tree view you can use `eza -lt`, where you can add `-s type` to the end to sort directories first.  From here you can open `yazi` and look around the directory.

The root of the repository contains the *flake* files that are used to control the output of the commands you use to change and update your system. From the `flake.nix` file, all other files are eventually imported for evaluation.

The `configs` directory contains all config presets you make. This is where you keep all config files that don't contain any hardware specific settings, allowing it to be shared across devices. It is possible to only have one config file for all your systems and only manage options in the hardware files of each system, but it can be useful to create presets files that 

The `hardware` directory contains all hardware specific settings and configurations such as; Graphic drivers, Disk partitions, available users and anything that needs special settings to accommodate hardware limitations.

The `modules` directory just has files that are imported to every config file. They are made of the *options-config* syntax that specifies an available option and what it does. With this you can have reusable parts that can be used to enable/disable predefined settings. All files are imported recursively, so the directory names and structure don't matter and are just for organisation.

The `library` directory just contains snippets of nix code (expressions) that you create and want to reuse. All files get imported in the flake.nix and are thus available anywhere.

### Packages & programs

NixOS is a Linux distribution based on the nix package manager, so how do you install packages? You simply write them down inside a list in a .nix file.

If you open `configs/template.nix` and scroll a bit down, you'll see a commented line that says `<< System packages >>` and below it will look a bit like this:

```nix
{
 #====<< System packages >>====================================================>
  services.flatpak.enable = false;       # See "flatpaks" for more info.
  /* Below is where all the sytem-wide packages are installed.
  Go to https://search.nixos.org/packages to search for programs. */
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ 
   #==<< Terminal Programs >>==========>
    zellij    # User friendly terminal multiplexer.
    helix     # No nonsense terminal modal text editor.
    yazi      # Batteries included terminal file manager.
   #==<< Terminal utils >>=============>
    zoxide    # A better cd command that learns your habbits.
    eza       # LS but with more options and customization.
    bat       # Better cat. Print out files in the terminal.
    starship  # Shell promt customization tool.
    btop      # Better top, a resource monitoring tool.
   #==<< Other >>======================>
    alacritty
    git       # Best learn to use git. it *WILL* make your life easier.
    gitui     # Git terminal user interface written in rust.
  ];
}
```

The first line is just if you want to enable flatpaks (you shouldn't), but below that is a list called `systemPackages` and inside that list you'll find a bunch of entries such as `helix`, `eza` and `yazi`. These are some of the programs I have included for you to get started, but of course you can remove them and replace them with what ever you want.

An important thing to note is that these are of course not all of the packages included with your system. In the `modules` directory, you'll find files that, when enabled, install a bunch of packages. This is because to use this module, you'll need the packages provided, so if this module/option is enabled, then these packages will be included automatically. 

The Default NixOS module basically works the same as it's supposed to provide a fully functional operating system. This means that packages such as the GNU `coreutils` package is installed by default and many more that are common on other distributions.

The default module is fairly minimal, especially if you have no desktop environment, so even if you are a minimalist *freak*, you won't have to remove any packages. This is good as currently, excluding packages from the base NixOS module is very hard. But if you want to remove packages provided by desktop environments, you can search for `excludePackages` in the option search, and put the packages you don't want in the one for your DE.

To find packages, go to https://search.nixos.org/packages. Here you can search for package in either the unstable channel, or the current stable channel. You can also search for `options`, which are nix expressions you can put into your nix config files. Try searching for `users` to see options containing anything with users, or `programs` to see all options to provided programs.


### Module system

### Commands

##### switching configs

To apply any of the changes you have made to your config, you'll need to execute a command like in any package manager when you update (like `apt upgrade`). On NixOS this command is:

```shell
sudo nixos-rebuild <option> --flake /path/to/flake#<configuration>
```

Here `nixos-rebuild` is the command that creates a new profile based on the provided configuration. `<option>` is how you want to output the new build, where you can either:

- `switch`. This takes the new configuration and activates it once the build finishes.
- `build`. This just build the result into a `result/` directory. this can be used to test for any errors without activating the configuration if it passes.
- `test`. Same as switch, but does not add a new profile to the bootloader.
- `boot`. Builds a configuration and adds it to the bootloader, but does not activate it.
- `build-wm`. Builds a virtual machine to test the new configuration.

The `--flake` flag makes it so the rebuild will look for a `flake.nix` instead of a `configuration.nix`. The path behind it is the path to the flake, the default being `/etc/nixos`, but you can change this with the following in your nix configuration:

```nix
{
  nix.nixPath = [ "nixos-config=/path/to/flake" ];
}
```

The `#<configuration>` specifies what configuration to use. If this is dropped it will instead look for a configuration with the same name as your hostname. This will become more clear in the [Flake](#flakes) chapter.

With the nix path set, and assuming that your flake has a configuration named after the hostname of your system, you can drop the later part and only type:

```shell
sudo nixos-rebuild switch --flake
```

You can also rollback to previous configurations using the `--rollback` flag like so:

```shell
sudo nixos-rebuild --rollback switch
```

##### updating system

Since this config uses flakes, in order to update your system/packages, you'll need to update the `flake.lock`. You do this by using:

```shell
nix flake update <input>
```

The `<input>` option is used to specify which input to update. if it is dropped, all inputs will be updates and such the entire system. You still need to run a `nixos-rebuild` command to apply the changes.

##### garbage collection

When updating the system, all old packages are kept, otherwise you wouldn't be able to rollback to previous configs. To delete old generations you no longer wish to keep, use:

```shell
sudo nix-collect-garbage -d
```

This deletes all old generations and packages used by them. If you want to keep some generations, you can replace the `-d` flag with `--delete-older-than <period>`, where period can be: `3d`, `21d`, `365d`, etc.

##### other comands

Some other useful commands are:

- `nix repl`. This a repl command for Nix that allows you to test out nix expressions and code. Type `:q` to quit. Learn more [here](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-repl.html).
- `nix shell`. This command creates ephemeral environments with any package you specify either on the command-line with `-p`, or in a `shell.nix` file in the current directory.


# Confusing flakes

If you have been using NixOS or used it before, you'll undoubtedly have heard people mention "flakes". In fact I have mentioned them a lot in the text leading up to this chapter. But what are flakes? The name isn't exactly descriptive and everyone seams to describe flakes in different ways? Why would you even want to use flakes?

### What do flakes even do?

Flakes in their most common usage are just version pinning for packages. They replace the `nix-channel` with a more declarative and integrated way of managing channels and other inputs. The `flake.lock` is created by the inputs in the `flake.nix` and this is used to find the exact version of the packagers you want, ensuring full reproducibility.

Flakes also have other features, in fact they have quite a lot of features, maybe even to many. One thing they do is that they do not allow the use of any file that isn't being tracked by git, making sure that the configuration can be recreated with only the repository. But this means having certain files that contain host specific options that isn't tracked by git is no longer an option. But flakes provide a solution to that with another feature.

Flakes provide a way to create multiple predefined configurations

This is essentially what flakes are, an *input-output* control centre where you can version all your inputs and packages and manage all your different hosts an example of a minimal flake would be:

```nix
{
  description = "My flake!";
  
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  
  outputs = { nixpkgs }: {
    nixosConfigurations.<HOST> = nixpkgs.lib.nixSystem {
      modules = [ configuration.nix ];
    };
  };
}
```

### Inputs

The inputs attributeset is what controls what goes into the `flake.lock`

```nix
{
  inputs = {};
}
```

inputs can be used to use both the unstable and stable channels

To access inputs in the configuration the `@inputs` argument is used

then you need to specify the system

### Outputs

Configurations

host specific stuff

dev shells

other (pkgs, modules, overlays)

### Flake automation

Less is more. if automation is more, then it is less

Snowfall, flake parts, flake utils

### The monolith

Too much?

do you even need them

Middle of the road, use as little as possible, do not use pkgs or modules.


# Home-manager

### Purpose

### Environment & shell

### Dotfiles

### Custom desktop environment


# Disko partitioning

### Disko

### LUKS

### Btrfs

### swap


# Remote *re*deployment

### Secure Shell (ssh)

### Setting up NixOS-anywhere

### Creating a custom ISO

### Installation script

### The boot process


# Other resources

### Nix helper

### Stylix

### Impermanence

### Lanzaboote

### Sops-nix

In daily use of any computer system, there are many configurations that need to be kept hidden, and so can't be kept anywhere where they can be easily accessed by other people, like in a public git repository, a private one with many users or in the nix store where it is available to anyone with access to the computer.

### Lix