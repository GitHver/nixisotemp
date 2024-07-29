
# Overview

SputNix is a newbie ready flake for NixOS. The goal is to make a configuration that works out of the box, while also teaching the user how to navigate their system. if you want to learn more about NixOS, you can go to https://nixos.org/explore/ and see if NixOS is for you!

This guide is structured as followed:

- Flashing a USB and booting from it
- Installing NixOS with the Calamares installer
- Setting up Flakes and home manager
- Getting to know the basics of navigating the terminal
- Learning git basics
- Learning some basic Nix syntax
- A collection of resources to get to know Linux better

# Installation

If you already have a NixOS machine up and running and you're just looking for a starter config, then skip to the [Configuration](#configuration) chapter.

### ↓Flashing an ISO image to a USB drive

The first thing you'll need is a USB thumb drive. Go to https://nixos.org/download/ and scroll down to *NixOS: the Linux distribution* and click on the `download (Gnome, 64-bit intel/AMD)` button. When it is finished, verify the integrity of the image with sha256.

Now you need to flash the ISO image to the USB drive. You can use either [Etcher](https://etcher.balena.io/) or [Ventoy](https://www.ventoy.net/en/index.html). I recommend Ventoy, as you can have multiple ISO images on it while also storing files. This way you can download both a NixOS ISO and a Windows ISO, so if you want go back or something goes wrong, you can just boot back into Windows with out needing a second computer to redownload and flash the ISO. You can even jump to the [Configuration](#configuration) section and pre-configure your system and store it on the Ventoy drive.

### ↑Booting from the USB

To boot from the ISO on the USB, open the power menu, Hold shift and click restart. If this doesn't work, you need to restart/turn on your computer, and hit either: F2, F12 or Delete when the computer is booting. A splash screen image might say which one you need to press. With that you should be but into BIOS or UEFI interface.

there is no standard interface, so you'll have to navigate the menus yourself. But the things you need to make sure are true is:

- To disable secure boot, as it has nothing to do with security or safety.
- Make sure SATA mode is not in any RAID configuration. Set it to AHCI.
- Move the USB to the top of the boot priority.

Then hit F10 to Save and exit the BIOS/UEFI environment. 

### Calamares walkthrough

You should Now be greeted by a live environment of NIxOS Gnome. The Calamares installer should launch automatically. simply follow the instructions it provides 

*Notice: the newer NixOS ISOs are bit wonky with the installer. If you encounter any bugs in the UI, input or installation proccess, refer to [Troubleshooting](#Installation-troubleshooting)*

1. ***Welcome***. Here you are prompted to chose a display language. Chose the one you want to use.
2. ***Location***. Here you can chose the timezone region you are located in. This will also automatically make your time and date formats for the selected region. If you want different formatting from the region you are located in, press the `change...` button on the time and dates entry.
3. ***Keyboard***. You need to select the layout you have for your keyboard. Look it up If you don't know, but it should just be the language you speak. For the keyboard variant, you can leave it empty, but if you know what your keyboard is, then select the appropriate one.
4. ***Users***. In the first field, put what you want your account to be called, your display name (this is what will be displayed when you log in on your system). The field below is your actual username. It will be the same, but in lowercase and without any spaces, but it doesn't have to match. Next type in your password, and then the root (administrator) password. you wont have to use it a lot, maybe even ever, so put it to memory. If your afraid that you'll forget it, then tick the box that makes he root password the same as your password. Better to have *less* security than to be locked out of your system.
5. ***Desktop***. Here you can chose a desktop environment. It's basically what makes your computer work, feel and look the way it deos. For this guide, we'll use Gnome, and the provided home.nix also uses Gnome, so unless you **absolutely** know what you are doing here, pick Gnome.
6. ***Unfree Software***. This is a checkbox to allow non free/open source software; programs and libraries, to be installed on your system. You should click this box if you plan on using things such as: Discord, Spotify, Davinci resolve and NVIDIA drivers, among a thousand other things. Nonfree software is not safe as it can't be verified to be safe. Malicious bugs and backdoors to your system can be hidden in the source code with no way to know. If you don't want any unfree software on your computer, maybe [Guix](https://guix.gnu.org/) might be of interest to you?
7. ***Partitions***. Here you will select your partition layout. You can pick what ever you want, but beware Windows is know to be a bitch with dual booting. The easiest option is to just erase everything, as a virtual machine setup is provided in the configuration. If you chose to encrypt your drive, then be sure to remember to paste the relevant lines into your hardware.nix in the configuration process.
8. ***Summary***. An overview of everything so far. Take a good look here and make sure everything is correct and the way you want it.
9. ***Installation***. And now you wait! Note: the installer will "get stuck" at 46%. this is because there are 11 steps in the installation process, and the sixth one takes by far the longest, so don't worry! 5/11 = 46%. You can press `show logs` to see what is happening during the installation.
10. ***Finish*** Check the box to restart your system and you are Done!

The system should now restart an you should boot up on the drive you installed it on, so it is safe to unplug the USB drive.

### Installation troubleshooting

If everything went smoothly, skip to [Configuration](#configuration)

If you encounter any problems in the Calamares installer, the reason is likely the fact that the recent NixOS ISOs have come with broken installers, likely do to the recent NixOS "situation". Everything from the drop-down menus being buggy, the keyboard not switching languages and the mounting failing if you have a swap partition.

Luckily most of these problems are solved by using an old version of the NixOS ISO. Go to [This Site](https://releases.nixos.org/?prefix=nixos/) and choose and older version, like 23.11 to 22.05 (no need to go any further back). Your desktop will be a bit out of date during the setup, but once everything is done, you can update the system and the latest versions of everything will be installed.

If you got an error that the mounting of the partitions failed and you don't wan't to download another ISO form whatever reason (slow internet or just lazy), or no ISO version you try works, you'll have to fix this by manually partitioning your drives yourself.

You'll need to open GParted and erase all partitions. If you can't erase some of the partitions, you'll need to open gnome disk (should just be called 'Disks') and select the partitions you can't remove and then press the button with the *cog* symbol on it and select *format partition...*. just format it to a ext4 partition; it doesn't really matter. Now you should be able to delete the partitions in GParted.

Now open and close the installer and go through the proccess again and it should work now, but if for some reason it doesn't, repeat the steps above (make sure all partitions are deleted) and once you get to the part in the installer that ask how you want to partition your drives, select `manual partition`.

#### Manual Partitioning

***Firstly***; you need to decide how you want to partition your drives. Most partitions will look the same, but if you need anything special like Btrfs or a separate home partition, you'll need to make out the details yourself.

***First partition: The Bootloader***. The first partition you need to make is the bootloader. As everything should be free space, just click on `create` and from there, make the filesystem fat32, select the mounting point to `/boot`, and make the flag `boot`. The size should only need to be 512 MiB as that is the default.

***Second partition: SWAP***. If you plan on using a SWAP file, or think you don't need SWAP, then you can skip this partition. Select `create` again on the free space and make the filesystem 'Linuxswap' and make the flag `SWAP`. Depending on if you plan on having hibernation the size of your SWAP will vary. If you want hibernation, a good rule of thumb is 'size of your RAM + square root of your RAM', example: if you have 16GB then your SWAP partition should be 20GB. If you don't need hibernation, then 8GB should be enough for all RAM sizes, as on the lower end (4-8GB), you need all the space you can get, and on the higher end (16-64GB), you have enough RAM and don't need to proportionally increase the SWAP, but of course, you can put any size you want/need.

***Third partiton: Root***. This is where all the system files and packages will be stored. This should be enough to store all packages you need on the system + all other versions you will keep in order to boot into older generations. 50 - 100 GB should be well enough. If you aren't planning on making a separate home partition, then make this partition the rest of the available space. Make the filesystem ext4, set the mounting to `/` and make the flag `root`.

**Optional** ***fourth partition: Home***. Here you can make a partition for your home directory. By separating your /home from the root, you can easily back up your personal files and switch between distributions (why whould you?). This also allows you choose a different filesystem like btrfs for snapshots of your home directory, as you wouldn't want that on your root as Nix already provides all the btrfs features you would want there like snapshot rollbacks and upgrade safety. But as NixOS makes everything Immutable (Read only), except for your home directory, by making the home directory a separate partition you gain a more "physical" distinction between the immutable root and the mutable home. Finaly, this also "somewhat" mitigates fragmentation of files, keeping system files close together and your personal files close together. So choose your filesystem, make it the rest of the available space and mount it to `/home` with the `home` flag.

This should be all you need to know for your first installation. If you need some more guidance on partitioning your drive then just look up some partition layouts on the interweb.

# Configuration

Once you're in your new NixOS system, you should open the terminal. it should be called "Console" and be on your dash when you press the super (win) key. If not it should be in the utilities folder in the applications view. To access the applications view, double press the Super key or Super+a. you can also press the super key once and search for it by typing "console". you wont use it yet but have it open. you should also open Files (nautilus) and Text editor (gnome-text-editor). These are the three applications you'll need for these next parts.

### Enabling flakes

Flakes are the holy grail of making reproducible systems. It pins your sources and versions in a flake.lock file. With flakes you can use both the "rolling release" unstable channel, and any stable channel you like. Gone are the days of choosing between stability or the bleeding edge. With flakes, you get both!

To be able to use flakes, open Files and click on `other locations` and then `NixOS` → `etc` → `nixos`. You can also click the magnifying glass icon at the top and type /etc/nixos to go straight to the directory. 

Once you are in /etc/nixos, open `configuration.nix` with the Text editor and paste the following in below the first function in the main scope: 

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

the file should now look like this:

```nix
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
```

ctrl+s to save and then close the program. then put the following in the terminal: $`sudo nixos-rebuild switch`. And now you have access to flakes and can procced with customising your system.

### Downloading the repository

Now that you have flakes and are able to build from any directory you can download the repository and begin configuring your system. this is usually done with *git*, but you'll learn about that later and have your own repository up and tracking. If you know how to use git, simply clone the repository and skip to [Hardware](#Hardware).

Open firefox and go to the SputNix github repository and got to the top where it says `CODE` in a green box and select 'download zip'. Once it's downloaded, open up the 'files' program and go to downloads. Here you should see `SputNix-main.zip`. Right-click on it and select `extract to...` and in the new pop-up window click on `home` on the right side and the click `select`.

Once this is done navigate to your home directory in files and you should see a new directory named 'SputNix-main'. Rename the directory by right clicking on it and selecting `rename` and erase the '-main' so it should just read: `SputNix`. Now open the directory and open and follow the instructions below.

### Hardware

In the console paste the following: $`cp /etc/nixos/hardware-configuration.nix ~/SputNix/hardware/template`. This copies your hardware scan to the template directory. additionally it also makes the owner root so you need root privileges to change it, which is good as yous should not be changing anything in this file and instead but any additional host-specific options in the hardware.nix in the template directory.

Decide on a hostname for your computer. This is just the name of your computer on the network. if you have for example a Lenovo yoga slim 7, then your hostname could be "slim7". your terminal will then display: `[user@slim7:~]$`

Once you have decided on a hostname, open variables/hostname.nix and replace 'your-hostname' with your desired hostname, then go into the hardware directory and rename template directory to the hostname you chose.

You can leave this step for when you're done setting up the system, but you can go into hardware.nix and uncomment in the imports the relevant drives for your computer if you have an and AMD or an NVIDIA GPU.

```nix
 #====<< Import all device specific modules >>=================================>
  imports = [
    ./hardware-configuration.nix
    #./amd-drivers.nix      # If you have an AMD GPU
    #./nvidia-drivers.nix   # or If you have an Nvidia GPU
  ];
```

### Porting localisation

Sets the language and keymap for your system. Here is the field in SputNix/configs/default.nix, down near the bottom.

```nix
 #====<< Localization >>=====================================================>
  time.timeZone = "Europe/London";
  i18n.defaultLocale  = "en_GB.UTF-8";  # Set default localization.
  extraLocaleSettings = "en_GB.UTF-8";  # Set other localization.
  console.keyMap = "uk";                # Sets the console keymap.
  services.xserver.xkb = {
    layout = "gb";                # Set the keymap for Xserver.
    variant = "";                 # Your keyboard's variation, e.x  "104-key",
  };                              # is not required.
```

You can find your current localization in /etc/nixos/configuratin.nix. It's the huge block that ends with .UTF-8 on every line. If you chose one language for the system language e.x 'English United Kingdom' and use a different display language e.x 'Icelandic' then the default language will be in the `i18n.defaultLocale` (e.g English, en_GB.UTF-8), and the extraLocaleSettings will be your preffered language (e.g is_IS.UTF-8). it would look something like this:

```nix
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "is_IS.UTF-8";
    LC_IDENTIFICATION = "is_IS.UTF-8";
    LC_MEASUREMENT = "is_IS.UTF-8";
    LC_MONETARY = "is_IS.UTF-8";
    LC_NAME = "is_IS.UTF-8";
    LC_NUMERIC = "is_IS.UTF-8";
    LC_PAPER = "is_IS.UTF-8";
    LC_TELEPHONE = "is_IS.UTF-8";
    LC_TIME = "is_IS.UTF-8";
  };
```

Which would look like this in default.nix

```nix
  i18n.defaultLocale  = "en_GB.UTF-8";  # Set default localization.
  extraLocaleSettings = "is_IS.UTF-8";  # Set other localization.
```

If you use one language for every thing, then it would probably look like this:

```nix
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
```

in this case both `i18n.defaultLocale` and `extraLocaleSettings` will be 'en_US.UTF-8'

This huge .UTF-8 block that is generated has been moved to a module and is controlled by the "extraLocaleSettings". See more by opening localization.nix in the modules directory and you could learn how to create Nix modules and might learn some valuable Nix syntax!

### User management

Now go the variables directory again and open username.nix and replace the contents in it to the same as your username, it's the same as your home directory (open Files and go to other locations and go to the home directory and the name of the directory there should be the name in username.nix ). The username variable **_NEEDS_** to be the same as your home directory, else the rebuild will create a whole new user and delete the current one. For reference, this is where the variables are used;

```nix
 #====<< User management >>==================================================>
  users.mutableUsers = true;         # Makes the home directory writeable.
  users.users.${username} = {        # See variables at top ↑.
    description = "${displayname}";
    isNormalUser = true;
...
```

now chose a display-name you want to be seen as when you log in to your computer and then open displayname.nix and put it in there.  

### Packages

If you go to the configs directory and open default.nix, you can read all the comments in the file to get to know your system, but if you want any special packages, scroll down to *System packages* and you'll see this:

```nix
 environment.systemPackages = with pkgs; [ 
   #==<< Terminal utilities >>=========>
    zellij    # User friendly terminal multiplexer
    helix     # No nonsense terminal modal text editor
    yazi      # Batteries included terminal file manager
    git       # Best learn to use git. it *WILL* make your life easier.
  ];
```

Set any system packages you want on your system here inside the square brackets. for example: wget, ripgrep, python, rust, etc. all can be found on [The Nix package repository](https://search.nixos.org/packages). Check modules/utilities.nix for already installed packages.

**Steam an other special programs:**
Some programs require extra permissions to use fully. Steam needs firewall premissions to use online peer connection functionalities like remoteplay and server hosting. A module is available in the module directory that gives steam all the neccessary premissions. just uncomment the it in the imports list at the top of default.nix

### Final steps

now, assuming that you have set up all the necessary configuration into the config file, you can type the following into your terminal:

$`sudo nixos-rebuild switch --flake ~/SputNix-1#standalone`

This will rebuild your system according to your specification in the configuration file. If you get an error, read the middle line that says in red letters **ERROR AT:** or similar, as the issue is likely a spelling mistake. Don't worry, we've all been there.

If there is some other issue that you can't figure out the solution to on your own after searching the web for a while, then head to the nix forums and simply ask. While Nix users aren't always the most enthusiastic helpers, they rarely scold you for rookie mistakes, as everyone has their own opinion on what nix *should* be, but nix is currently a frankenstein'd specification after all the years of maintenance, so most negative energy is spent on veterans arguing about what nix could have been be, instead of condescendingly correcting newbies on what nix should be. Take note Arch users.

# Home manager

Home manager is an extension of Nix. It provides a ton of features aimed at making declaring your home directory a breeze. It comes with more options and all the same packages as the regular Nix. 

Nix is meant to declaratively manage your system, with users mostly imperatively managing their home environment. Anything done through the regular Nix is done system wide. This may be the desired outcome, but it is good practice to not install/apply anything system wide that does not need to be so. 

Home manager's options make it so that no matter what computer you are on; your user setting, programs and configurations are declarative and reproducible.

### Standalone vs module

There are two ways you can install home manager; standalone or as a module. The standalone uses a separate command to rebuild, while the module approach imports itself through the main configuration with. 

For the most part, there is no difference between the two, but there is one big difference, and that is that the standalone version allows users to manage their home and packages without needing admin privileges. Standalone also doesn't currently support a comfortable rollback util. This is not a problem, as home manager isn't going to break your system and with proper version control you can just rebuild the old version again, but it's still a thing you lose on (though you can manually roll back by changing home configs). In the module configuration, you can just use the boot menu rollbacks as each rebuild makes a new entry.

Here are some things to keep in mind when choosing which version you want. If you find your think the things on the left side fit your situation more, go for a Standalone setup, and if you think the left one makes more sense, go for a module setup.

| Standalone use cases | Module use cases |
| --- | --- |
| Multiple users | Only user/personal-computer/laptop |
| Don't want to update system components along side user packages | want to be able too easily roll back changes |
| Want to keep the boundaries between the mutable home and the immutable root clear | want everything to be in one clear package |
| Want the same experience across all platforms | want to save 2 minutes |

### Module

The module approach simply imports the home.nix as a module, like such:

```nix
home-manager.users.<USERNAME> = import ./home.nix
```

There is already a confirmation in the flake.nix that does this so all you need to do is run: $`sudo nixos-rebuild switch --flake ~/SputNix#module`, but before you do, go to [options](#options) and personalise your home before you build it

### Standalone

The other way is to use the stand-alone installation. With this each user can manage their own home without sudo privileges. This also removes most user settings away from the system config.

To install home manager in a standalone configuration, you first need to imperatively add it to your system, as home manager declaratively manages itself, it needs to bee bootstrapped to the system.

First open your terminal and run the following:

$`nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager`

Then: $`nix-channel --update`

*You might need to log out and in again if the below command does not work. If that isn't enough, try restarting your system*

$`nix-shell '<home-manager>' -A install`

And now it is done! you can now use home-manager as a sudo-less installation of Nixpkgs, or to declare you home directory and manage you dotfiles.

There is a shell alias provided in home.nix that makes $`rebuild-h` rebuild your home configuration, but it is declared in home.nix so for it to be used, you need to rebuild once, the command is: $`home-manager switch --flake ~/SputNix/user#your-username` **BUT** you should first check out [options](#options) below and personalise your home before switching configurations.

### Options

Go to the user directory and open the variables directory and edit the hometype.nix file. If you are doing a standalone setup, write 'standalone', and 'module' for a module setup. Then edit username.nix and put your username there.

'system-path.nix' only matters for if you want to move or rename the SputNix directory. If you do you'll need to rename the homemanager-path accordingly, unless you are using a standalone home-manager setup, in which case you can take the user directory out of the SputNix one if you want to, as it is not bound by the system configuration in any way. Just remeber to rename the path.

Now you can open home.nix in the user directory and take a look around...

If you scroll down to User Packages you'll see this:

```nix
 #====<< User Packages >>======================================================>
  nixpkgs.config.allowUnfree = true;
  # Below is where your user packages are installed.
  # Go to https://search.nixos.org/packages to search for programs.
  home.packages = with pkgs; [
  
   #==<< Internet >>===================>
    firefox         # Fiwefwox! or
    #librewolf       # Pre hardened Firefox or
    #floorp          # A beautiful Firefox Fork
    #tor-browser     # Anonymous web browser.
    thunderbird     # FOSS email client.
    #qbittorrent     # BitTorrent client
    #signal-desktop  # Private messages.
    #webcord         # No telemetry discord  .

   #==<< Creativity >>=================>
    #obsidian        # Markdown file editor, or
    #logseq          # A FOSS alternative.
    #obs-studio      # Recording software.
    #davinci-resolve # Exeptional video editing software
    #blender         # 3D modeling and rendering software.
    #libre-office    # FOSS office suite.

   #==<< Media >>======================>
    #vlc             # Multi media player
    #spotify         # Music streaming service

   #==<< Terminal utils >>=============>
    wexterm         # Rust made terminal emulator configured in lua
    zellij          # User friendly terminal multiplexer, or
    #tmux            # A More known alternative,
    helix           # No nonsense terminal modal text editor, or
    #neovim          # A bigger ecosystem with plugins.
    yazi            # batterise included terminal file manager

```

Here you can see some programs that you might want to install, simply uncomment them to do so. If you want any other programs, just go to https://search.nixos.org/packages like with system packages, and search for the things you need

Once your done choosing packages, rebuild your home with either

$`sudo nixos-rebuild switch --flake ~/SputNix#standalone`, or

$`sudo nixos-rebuild switch --flake ~/SputNix#module` if you are using it as a module

And then find out about the *cool* quirk with home manager on gnome. When you are done building your home configuration after and you've added any programs to your user like Obsidian, VLC or Blender, you'll find that they don't appear in the applications menu. But if you open up your terminal emulator and type in the name of your program that you installed, e.x: obsidian, vlc or blender, then the program will launch.

Why this is, I don't know, but if you log out and log in again, everything will be as expected. It is because of this that I implore you to start making your own "desktop environment" with window managers like NiRi or Hyprland. After all, the strengths of Nix comes from being able to reproduce your system anywhere, so you only need to create your system once and after that your system and home configurations work as a blueprint to your own "Linux distro".

### Dotfiles

Work in progress...

# Continued usage

Your system is up and running, but if you want to get the mos out of it, you'll need to take a few more steps to get comfortable with your new system

## The terminal

Note: you do not actually need to use the terminal to do most of things in Linux, especially if you don't code, and your just using this as home computer. But getting used to the terminal will help you a lot when using Linux. It is scary at first, but once you use it for more than 10 minutes, I think you'll find realise why the terminal is still so prevalent on Linux systems, and that it is nothing like CMD on windows, but a fully functional computer interfacing environment. Even if you don't feel comfortable, you'll still learn a lot, and you only need it to update your system from here on out.

### Nix commands

You can run $`Nix --help` inn your terminal to get a list (press q to quit) of all available nix commands. Some common commands you'll need to know are:

- `sudo nixos-rebuild`
	- with: `switch`, `test`, `build`
	- and:  `--flake /path/to/the/flake#home-type`
	- example: `sudo nixos-rebuild switch --flake ~/SputNix-1#module`

- `nix flake update`
	- with `/path/to/the/flake`
	- example: `nix flake update ~/SputNix-1`

- `nix-collect-garbage`
	- with: `-d`, `-delete-older-than`
	- and: `3d` 3days, `5m` 5months, `2w` 2weeks
	- example: `nix-collect-garbage --delete-older-than 10d`
 
These all come pre-packaged with the home manager `home.nix` provided in `user/`, With `rebuild-s` and `rebuild-h` rebuilding the system and home respectively, `update-s` and `update-h` updating the flake.lock, `upgrade` which executes all of the previous commands, and finally `cleanD`, which deletes all packages exclusive to generations that have gone unused for more than a day with `CleanW` and  `CleanM` deleting older than one week and month respectively.

### General Linux commands

work in progress...

$`ls`

$`cd`

$`touch`

$`mkdir`

$`cp`

$`echo`

### Linux File Structure & /nix

Work in progress...

# Version Control

With everything being configured and controlled through text files, you may have realised that storing/backing-up your system can be easy and space efficient. You might have also noticed that when you revert to a previous configuration, your configuration files don't revert to the state of the current configuration, so in order to build upon your previous working configuration, you'll need to remember what was changed and revert to that state manually. This is not realistically achievable for any normal person, and so we need better solution to manage the versions of our configuration files.

### Git Version control

Git is a software version-control program. This means that it keeps track of files and any changes made to them. It takes snapshots of your repository when you make a commit allowing you to revert to that state of if you make any breaking changes. These snapshot also only keep the changes made each commit, so it stores no unnecessary information. Git also supports multiple *branching* development environments, allowing for different features to be made and tested in separate commits, which can be eventually be merged allowing all features to be pushed without conflict, even if all branches made changes to the same file as long as no one line was altered in two different ways.

Since Git is a *software* version control program, it is perfect for your configuration files. After all, Nix is a programming language, and your configuration files all amount to a small program. The way in which NixOS is used is also similar to 'code as infrastructure', so while you may not find configuring your system to be all to similar to "actual" programming, the skills you gain from Nix are all transferable to any programming environment.

### Initialising a Git repository

The repository you downloaded (this repository) has its own git directory named '.git'. You can't see it as it's name starts with a dot, making it a hidden file. to see, you can use `ls -a` or you can press `.` while in `yazi` to display all hidden files. Since you are here to learn git, you're going to delete the current repository and initialise a new one. In your terminal, put the following: `rm -r .git`, then use `git init`.

This will initialise a new git repository in your directory. you will automatically be on the `master` branch as that is the main and only branch. if you wish to rename it, you can use `git branch -m master release`. This will rename the specified branch (`master`) to the new name (`release`).

### Adding & removing files

You'll need to add the files you want to be tracked to the repository. You can do this with `git add name-of.file` . This will add the specified file to be tracked by git. If you want to add all files to be tracked, you can use `git add .`. to remove files, like ones you are planning to add later, or ones that just should not be tracked, use `git rm name-of.file`.

There are some files you never want to add to your repository, like temporary files, or build/compiled directories and binaries. To avoid having to remove them from tracking every time you want to make a commit, you can instead use a `.gitignore` file to list all files you don't want to be tracked.

There already is a `.gitignore` file in the repository that ignores all result/ directories. These are the directories that come when you use `nix build` to pre build something or when you make an ISO, so you don't need to change anything, but for your reference there is an explanation of all the syntax for making `.gitignore` files in the `.gitignore` file if you ever need to add something else.

### Committing changes

Git has no automatic saving, as it uses the difference between each version to save, a as such needs you to determine when to make a snapshot of the repository. To do this you use commits. You can think of each commit as a new version release of your system. Each time you make a change or add a feature you want to save before moving on to the next thing, you make a commit to save the current version to start working on the next version.

after you've added all the files you need to save, type `git commmit` in your terminal and you will be put into your current text editor where you need to write a comment about the current commit. E.x: "Changed the readme file to more accurately reflect the installation process". you can also use `git commit -m 'message'` to put the message you want without opening up the text editor. Just replace `message` with your message and the commit will go through.

To revert to a previous commit you can use `git reset commithash` where `commithash` is the hash of the commit you want to revert to. To find out what the hash of any commit is you can use `git log` and copy the hash or just use the first few characters, as it is very unlikely that any two commit have the same starting characters, and gets exponentially more unlikely with each character, so the first ~7 should do and git will automatically find the commit that matches those characters. This would look something like this: `git commit ca49d82`.

you can also use `git reset --soft commithash` to keep the changes made in the current directory. `git reset --hard commithash` discards all changes made in the directory effectively reverting the repository to the specified commit.

If you want to see the difference between your current directory and the last commit, you use `git diff HEAD`, and to see the difference between two commits, you can use `git diff commit1hash commit2hash`.

You can see more information about the current commit with `git show`, and to get information about any specific commit you simply add the commit hash at the end like so: `git show 48ddad7`.

`git restore name-of.file` restores a file to the state of the current commit effectively discarding all changes.

### Branching out

When working on many features and changes at once, it can be difficult do test them if they're all in the same staging area. With branches you can *branch* out your development environments. This way you can have many different versions going at the same time with out any interfering with the other or making breaking changes with out knowing which change is causing it.

By using `git branch testing` you make a new branch with the name `testing`, but you can name it whatever you want. Since you made this branch from the `master` branch, or whatever name you gave your main branch, the new branch will inherit the commit history from it, making them two branches currently identical. Using `git branch`, you get a list of  all current branches. To switch to a different branch use `git checkout branchname`, with `branchname` being the name of the branch to switch to.

In the new branch you can make changes and add or remove files and make as many commits as you want, but eventually you'll want to add all the new changes to your main branch. you can do this by going to the main branch and using `git merge branchname`. This will merge newest commit of the specified branch to the current one.

Now the two branches should be identical (unless you have made any changes to your main branch like commits or merges of other branches), except in their commit history. If you are using this branch as a testing environment before merging with the main branch, the you will probably be keeping the branch. But if the branch you made was for a specific feature, then it is probably not needed anymore and by using `git branch -d branchname` you can delete the specified branch from the repository.

### GitUI

GItUI is a program that brings a UI to your git workflow. you can use it to check logs in a more easily accessible manner. You can even make all your commits and merges from here. It is an invaluable tool, but not every computer you will use will have it, so it is best to get a bit used to using git from the commandline before starting to integrate on GitUI into your workflow. To use GitUI, just type  `gitui` while in the root directory of the git repository.

### Adding a remote repository

After all this you might want a place to store your repository, so that you can fetch it from anywhere, and should anything happen to your computer, it won't be lost forever.

There are many ways to do this, including hosting your own server, but for most people, it's best to use some established git hoster, like GitHub or GitLabs. If you want to use any of them, simply go to those sites and look for how to make a new repository. Once that's done you can use  `git remote add name url` to add that repository as a remote.

Once you have a remote repository, you can use `git push` to push all changes you've made to the remote repository. `git fetch` fetches all changes from the remote, for if you have made any changes on another machine or on the site itself. `git pull` fetches all changes from the remote and automatically merges them (beware of any possible merge conflicts). On a new machine you can use `git clone url` to copy the repository to the new machine.

### More documentation

This should be well enough for most everything you will need to do with git. There are some more things such as notes and tags, advanced shortcut commands and some general concepts on how version control works under the hood, but for now this should suffice. If you ever need to learn anything more, simply checkout the [git documentation](https://git-scm.com/docs/git) or just search up a git cheat sheet if you need a refresher on available commands.## Virtual machines

Work in progress...

## Nix syntax'

Work in progress...

## Further Reading

Work in progress...
