
# SputNix

Welcome to the Sput*Nix* Repository.

This Repository aims to solve one problem: Getting started with NixOS is extremely tedious. The documentation can often be really shallow and it's all scattered throughout the internet like a broken vase.

SputNix aims to be a one-stop shop for all the basics that you need in order to have a functional configuration at the start of your NixOS journey with all the features you would have otherwise found yourself rewriting your configuration in order to accommodate, like Flakes, Home-manager or Disko, while also explaining what these are, why you want them and how to modify them to your preference.

It is best if you know some Linux basics and how to navigate a terminal user interface, but this is not required. You should however learn [Git](), as it will make your life much easier, but you can learn it as you go.


# Installation ISO

> [!IMPORTANT]
> Even if you already have a Working NixOS system it can still be valuable to read through the following section, as it goes over *Disko* and user management. Otherwise, skip to [Configuration](#configuration).

### Installing the ISO

For this guide I have provided a custom ISO for you to use. It comes with many helpful utils and bash aliases to make the installation near automatic. Beware though that by downloading this ISO you are trusting that I have not bundled any malicious software with it. You can see the contents of the ISO in the `hardware/!configs/ISO-image.nix` so if you do not trust me, you can use the minimal ISO provided by nixos.org and a see what each command does for yourself. by the end you will also be able to make your own ISO mage.

[Link to ISO download]()

The first thing you'll need is a USB thumb drive to flash the ISO to. You can use either [Etcher](https://etcher.balena.io/) or [Ventoy](https://www.ventoy.net/en/index.html). I recommend Ventoy, as you can have multiple ISO images on it while also storing files. This way you can download both a NixOS ISO and a Windows ISO, so if you want go back or something goes wrong, you can just boot back into Windows with out needing a second computer to redownload and flash the ISO.

### BIOS and booting

To boot from the ISO on the USB, open the power menu, Hold shift and click restart. If this doesn't work, you need to restart/turn on your computer, and hit either: `F2`, `F12` or `Delete` when the computer is booting. A splash screen image might say which one you need to press. With that you should be but into the BIOS/UEFI interface.

there is no standard interface, so you'll have to navigate the menus yourself. But the things you need to make sure are true is:

- To disable secure boot, as it likely won't let you boot otherwise. *see also*: [lanzaboote](https://github.com/nix-community/lanzaboote)
- Make sure SATA mode is not in any RAID configuration. Set it to AHCI.
- Move the USB that you are booting from to the top of the boot priority.

Then hit `F10` to Save and exit the BIOS/UEFI environment. On boot you will be prompted to chose boot options, just hit enter to chose the default options.

### Keyboard input

Currently, changing keymaps during the installation is more of a hassle than it is worth, so you are stuck with the uk keymap. Don't worry, you will have whatever keymap you use for your language once the installation is complete, and when you make your own custom ISO it can come with whatever keymap you want. For now, just Search up an image of the uk layout and use it as reference to find your keys.

### Internet

The first thing you want to do is connect to the internet. If you have an Ethernet cable, use that, else your going to have to connect to wifi. To do so, type in the following:

```shell
nmcli device wifi connect "your wifi's name" password "your wifi's password"
```

It should say that you have successfully connected with to your wifi. you can test it by pinging any site, try:

```shell
ping gnu.org
```

When you see packets being sent, hit ctrl+c to stop pinging. Next, type:

```
get-repo
```

This is just an alias to `git clone` the repository from GItHub so that you don't have to type out the url yourself.

### Disk partition

We'll be using Disko to declaratively partition your drive. Go to the yazi pane and navigate to `hardware/template` and open `disko.nix`. In the other pane, use:

```shell
lsblk
```

This will show available drives/devices to be used. There should be two drives; your USB you are currently booting from, and the drive you want to install NixOS onto. Find the correct drive and put it's name (`sda`, `nvme0`, `vda`) into the `device` field. example: If the name of your drive is `nvme0n1`, then it should look like this:

```nix
  disko.devices.disk.main = {
  
    device = "/dev/nvme0n1";
    type = "disk";
    ...
```

The current setup should be fine for most. But if you want swap with hibernation then change `resumeDevice` to be `true` and set the swap size to about the size of your RAM + the square root of your RAM. Example: with 16GB of RAM, your hibernate swap should be 20GB (16 + 4). We will go more in depth on partitioning on the second remote install, so don't worry to much about setting up your partitions.

> [!CAUTION]
> Make sure you have the right disk. The selected disk will be completely wiped 

When you're done setting up your drive exit by going into normal mode with escape, then `:wq` and enter to write and quit. Now in the command panel type:

```
mount-disko
```

This will take a short while, but if it fails for whatever reason, try fiddling with the size of the swap (like seting it to 9GB instead of 8GB).

Now you need to run a provided alias that generates a config for your system's hardware:

```
generate-config
```

### Host configuration

You'll need to decide on a hostname for your system. It can be anything, but best to make it something that is connected to its actual name or physical structure, for example; if you have Lenovo Yoga Slim 7, the hostname could be `slim7`, or if your computer's case is a fractal north terra the hostname could be `fn-terra`.  Once you've done that open the `flake.nix` file at the root of the repository and scroll down to here:

```nix
  nixosConfigurations = {

    #==<< Template configuration >>=============================================>
    YOUR_HOSTNAME = let hostname = "YOUR_HOSTNAME" in
    nixpkgs.lib.nixosSystem {
      modules = [ ./hardware/template/hardware.nix ];
      specialArgs = { inherit inputs alib patt hostname; };
    };
```

Here you need to change all `YOUR_HOSTNAME`'s to the hostname you want and then save the file. Next navigate to the `hardware` directory and then rename the `template` directory to your hostname.

### Users

Now decide on an username and a displayname. The username will be the one used to refer to your user in everything is is your actual username, It can't be uppercase or contain any spaces. Your displayname is what is shown when selecting users in the display manager (log-in screen) and can contain spaces and any characters. Once you have decided, go to the `users` directory and open the example-user.nix file.

```nix
{
  #your username
  un = "example-user";
  #your displayname
  dn = "Example User";
}
```

Now change the `un` (username) variable to your username, and then the `dn` (displayname) variable to your desired displayname and the save and exit and then rename the file to your username(`.nix`).

### Localization

Now scroll down to here:

```nix
 #====<< Localization & internationalization >>================================>
  time.timeZone = "Europe/London";
  i18n.defaultLocale  = "en_US.UTF-8";  # Set default localization.
  extraLocaleSettings = "en_GB.UTF-8";  # Set other localization.
  console.keyMap = "uk";                # Sets the console keymap.
  services.xserver.xkb = {              
    layout = "gb";                # Set the keymap for Xserver.
    #variant = "colemak"          # Your preference.
    options = "caps:escape"; };   # Modification options.
```

What to do here is pretty straight forward:

- Change the `timeZone` to your timezone.
- Set the `defaultLocale` to the language you want your system to be in.
- `extraLocaleSettings` is all other locales (formating, time & date, measurements, etc).
- `console.keymap` is the keyboard layout in the terminal, like `"us"` or `"is-latin1"`
- xKeyboard, `xkb`, is your keyboard.
	- `layout` is your language layout (`"gb"`, `"ru"`, `"is"`).
	- `variant` is any specific variation of that layout (`"colemak"`, `"dvorak"`).
	- `options` is keyboard behaviour. Here `caps-lock` is an additional `escape`
	- These options are all mapped to the xkb options. see more [here]()

Now save and exit the template file.

### Choosing a desktop environment

Gnome
Niri
Hyprland

### NixOS install script

And with that you can now start the installation with:

```shell
sudo nixos-install --flake .#YOUR_HOSTNAME
```

Once that is done you will be prompted to set a new root password. "root" is basically just a user that is assigned to your computer, so really just ***The*** admin user. You will rarely ever be prompted to use this password, maybe never, but it is the key to your system so **don't forget it**. After that is done simply type `reboot` and hit enter.

> [!IMPORTANT]
> If you get any errors, read the middle line where the error is actually displayed and trace the file destination (usually down at the bottom), but remember to add all changes to git before trying to install again.

### Home manager bootstrapping

Now to install home-manager, so that you can manage user packages and configs without sudo privileges or affecting the system in any way. 

> [!NOTE]
> If you plan on using other means of dotfiles management, you might want to skip this step. However, home-manager can be used as a dotfiles symlinker, so migrating your configs is as easy as copying your dotfile directory into the `~/Home/dotfiles` directory.

Once you've booted into your system and logged in to your user account open any terminal emulator (Alacritty for example) and type in the following:

```
home-get
```

The use Yazi to navigate to the new repository and open the flake.nix file there. The only thing you have to do is go down to the `let ... in` block and change the `username` and `email` variables to their correct values, save and exit and then run:

```
home-install
```

If you open a new terminal instance, you will be placed into a fish shell. If you do not wish to use fish as your shell, go to `modules/shells/bash.nix` and comment out the `bash.profileExtra`


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
    btop      # Better top, a resource monitoring tool.
   #==<< Other >>======================>
    alacritty
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
sudo nixos-rebuild <option> --flake /path/to/flake#<configuration>
```

Here `nixos-rebuild` is the command that creates a new profile based on the provided configuration. `<option>` is how you want to output the new build, where you can either:

- `switch`. This takes the new configuration and activates it once the build finishes.
- `build`. This just build the result into a `result/` directory. This can be used to test for any errors without activating the configuration if it passes.
- `test`. Same as switch, but does not add a new profile to the bootloader.
- `boot`. Builds a configuration and adds it to the bootloader, but does not activate it.
- `build-wm`. Builds a virtual machine to test the new configuration.

The `--flake` flag makes it so the rebuild will look for a `flake.nix` instead of a `configuration.nix`. The path behind it is the path to the flake. The `#<configuration>` specifies what configuration to use. If this is dropped it will instead look for a configuration with the same name as your hostname. So an example of this usage would be:

```shell
sudo nixos-rebuild switch --flake /ect/nixos
```

You can also rollback to previous configurations using the `--rollback` flag like so:

```shell
sudo nixos-rebuild --rollback switch
```

Since this config uses flakes, in order to update your system/packages, you'll need to update the `flake.lock`. You do this by using:

```shell
nix flake update <input> /path/to/flake
```

The `<input>` option is used to specify which input to update. if it is dropped, all inputs will be updates and such the entire system. The path is the path to the `flake.lock` you want to update. You still need to run a `nixos-rebuild` command to apply the changes.

When updating the system, all old packages are kept, otherwise you wouldn't be able to rollback to previous configs. To delete old generations you no longer wish to keep, use:

```shell
sudo nix-collect-garbage -d
```

This deletes all old generations and packages used by them. If you want to keep some generations, you can replace the `-d` flag with `--delete-older-than <period>`, where period can be: `3d`, `21d`, `365d`, etc.

Some other useful commands are:

- `nix repl`. This a repl command for Nix that allows you to test out nix expressions and code. Type `:q` to quit. Learn more [here](https://nix.dev/manual/nix/2.24/command-ref/new-cli/nix3-repl.html).
- `nix shell`. This command creates ephemeral environments with any package you specify either on the command-line with `nixpkgs#<package>`, or in a `shell.nix` file in the current directory.


# Flakes

If you have been using NixOS or used it before, you'll undoubtedly have heard people mention "flakes". In fact I have mentioned them a lot in the text leading up to this chapter. But what are flakes? The name isn't exactly descriptive and everyone seams to describe flakes in different ways? Why would you even want to use flakes?

### What do flakes even do?

Flakes in their most common usage are just version pinning for packages. They replace the `nix-channel` with a more declarative and integrated way of managing channels and other inputs. The `flake.lock` is created by the inputs in the `flake.nix` and this is used to find the exact version of the packagers you want, ensuring full reproducibility.

Flakes also have other features, in fact they have quite a lot of features, maybe even to many. One thing they do is that they do not allow the use of any file that isn't being tracked by git, making sure that the configuration can be recreated with only the repository. But this means having certain files that contain host specific options that isn't tracked by git is no longer an option. But flakes provide a solution to that with another feature.

Flakes provide a way to create multiple predefined configurations

This is essentially what flakes are, an *input-output* control centre where you can version all your inputs and packages and manage all your different hosts an example of a minimal flake would be:

```nix
{
  description = "My flake!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs }: {
    nixosConfigurations.<HOST> = nixpkgs.lib.nixSystem {
      modules = [ configuration.nix ];
    };
  };
}
```

### Inputs

The inputs attribute set is what controls what goes into the `flake.lock`

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
