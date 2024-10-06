# Configuration

With your system up and running you can start to get to know your system and it's inner workings. The workflow you will have to get familiar to is very similar to the installation process. It involves a lot of interacting with the terminal, but in time, you'll wonder how you ever used a computer with out it.

### Structure

If use `cd /ect/nixos` or `zn` you will go into the directory containing the configuration you modified during the installation. To see the directory in a tree view you can use `eza -lt`, where you can add `-s type` to the end to sort directories first.  From here you can open `yazi` and look around the directory.

```
.
├── assets
│  ├── loginscreen-light.jpg
│  └── loginscreen.jpg
├── hardware
│  ├── !template
│  │  ├── users
│  │  │  └── user.nix
│  │  ├── disko.nix
│  │  ├── hardware.nix
│  │  └── users.nix
│  ├── a4h2o
│  │  ├── users
│  │  │  └── user.nix
│  │  ├── disko.nix
│  │  ├── hardware-configuration.nix
│  │  ├── hardware.nix
│  │  └── users.nix
│  ├── ISO-image.nix
│  └── configuration.nix
├── library
│  ├── makeusers.nix
│  └── recursiveMerge.nix
├── modules
│  ├── hardware
│  │  ├── amdgpu.nix
│  │  ├── nvidia.nix
│  │  └── virtualization.nix
│  ├── module1.nix
│  ├── module2.nix
│  └── module3.nix
├── flake.lock
├── flake.nix
├── license.txt
└── readme.md
```

The root of the repository contains the *flake* files that are used to control the output of the commands you use to change and update your system. From the `flake.nix` file, all other files are eventually imported for evaluation.

The `hardware` directory contains all hardware specific settings and configurations such as; Graphic drivers, Disk partitions, available users and anything that needs special settings to accommodate hardware limitations.

The `modules` directory just has files that are imported to every config file. They are made of the *options-config* syntax that specifies an available option and what it does. With this you can have reusable parts that can be used to enable/disable predefined settings. All files are imported recursively, so the directory names and structure don't matter and are just for organisation.

The `library` directory just contains snippets of nix code (expressions) that you create and want to reuse. All files get imported in the flake.nix and are thus available anywhere.

### Default config file

What you hear a lot about NixOS is that "Everything is configured in *one* config file". This can be true, but it is often unfeasible once you really start to get down to configuring the small details of your system.

### Packages & programs

NixOS is a Linux distribution based on the nix package manager, so how do you install packages? You simply write them down inside a list in a .nix file.

If you open `configs/template.nix` and scroll a bit down, you'll see a commented line that says `<< System packages >>` and below it will look a bit like this:

```nix
{
  #====<< System packages >>===================================================>
  services.flatpak.enable = false;       # See "flatpaks" for more info.
  /* Below is where all the sytem-wide packages are installed.
  Go to https://search.nixos.org/packages to search for programs. */
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ 
    #==<< Terminal Programs >>=========>
    zellij    # User friendly terminal multiplexer.
    helix     # No nonsense terminal modal text editor.
    yazi      # Batteries included terminal file manager.
    btop      # Better top, a resource monitoring tool.
    #==<< Other >>=====================>
    git       # Best learn to use git. it *WILL* make your life easier.
  ];
}
```

The first line is just if you want to enable flatpaks (you shouldn't), but below that is a list called `systemPackages` and inside that list you'll find a bunch of entries such as `helix`, `btop` and `yazi`. These are some of the programs I have included for you to get started, but of course you can remove them and replace them with what ever you want.

An important thing to note is that these are of course not all of the packages included with your system. In the `modules` directory, you'll find files that, when enabled, install a bunch of packages. This is because to use this module, you'll need the packages provided, so if this module/option is enabled, then these packages will be included automatically. 

The Default NixOS module basically works the same as it's supposed to provide a fully functional operating system. This means that packages such as the GNU `coreutils` package is installed by default and many more that are common on other distributions.

The default module is fairly minimal, especially if you have no desktop environment, so even if you are a minimalist *freak*, you won't have to remove any packages. This is good as currently, excluding packages from the base NixOS module is very hard. But if you want to remove packages provided by desktop environments, you can search for `excludePackages` in the option search, and put the packages you don't want in the one for your DE.

To find packages, go to https://search.nixos.org/packages. Here you can search for package in either the unstable channel, or the current stable channel. You can also search for `options`, which are nix expressions you can put into your nix config files. Try searching for `users` to see options containing anything with users, or `programs` to see all options to provided programs.

### Module system

### Commands

To apply any of the changes you have made to your config, you'll need to execute a command like in any package manager when you update (like `apt upgrade`). On NixOS this command is:

```shell
sudo nixos-rebuild <option>
```

Here `nixos-rebuild` is the command that creates a new profile based on the provided configuration. `<option>` is how you want to output the new build, where you can either:

- `switch`. This takes the new configuration and activates it once the build finishes.
- `build`. This just build the result into a `result/` directory. This can be used to test for any errors without activating the configuration if it passes.
- `test`. Same as switch, but does not add a new profile to the bootloader.
- `boot`. Builds a configuration and adds it to the bootloader, but does not activate it.
- `build-wm`. Builds a virtual machine to test the new configuration.
- `repl`. Opens the configuration in the Nix repl.

By default, Nix will look for a `configuration.nix` in `/etc/nixos`, but will use `flake.nix` if it exists instead and look for a confiuguration with the same name as your computers' hostname. If you want keep your repository somewhere else you can reference it by using the `--flake` flag and putting the path behind it. You can also build a specific configuration that is not your hostname by using a `#` followed by the name of the configuration you want to build - example:

```shell
sudo nixos-rebuild switch --flake ~/Nix/system#test-configuration
```

You can also rollback to previous configurations using the `--rollback` flag like so:

```bash
sudo nixos-rebuild --rollback switch
```

Since this config uses flakes, in order to update your system/packages, you'll need to update the `flake.lock`. You do this by using:

```shell
nix flake update <input> /path/to/flake
```

The `<input>` option is used to specify which input to update, If it is dropped, all inputs will be updates and such the entire system. The path is the path to the `flake.lock` you want to update, dropping it searches the current directory for a flake. You will still need to run a `nixos-rebuild` command to download and apply the updates to your system.

When updating the system, all old packages are kept, otherwise you wouldn't be able to rollback to previous configs. To delete old generations you no longer wish to keep, use:

```shell
sudo nix-collect-garbage -d
```

This deletes all old generations and packages used by them. If you want to keep some generations, you can replace the `-d` flag with `--delete-older-than <period>`, where period can be: `3d`, `21d`, `365d`, etc.

Some other useful commands are:

- `nix shell`. This command creates ephemeral environments with any package you specify either on the command-line with `nixpkgs#<package>`, or in a `shell.nix` file in the current directory.
- `nix repl`. This a repl command for Nix that allows you to test out nix expressions and code. Type `:q` to quit. Learn more [here](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-repl.html).
- `nix fmt`. The Nix formatter. formats your Nix code to a unified convention.