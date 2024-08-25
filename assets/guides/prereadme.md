
#### Table of contents

1. [Nix introduction]
2. [Terminal navigation]
3. [Installation]
4. [Git basics]
5. [Windows virtual machine]
6. [OpenSSH]

# Nix introduction

This guide is meant both for people new to Nix and Linux. No prior experience with Nix or Linux is expected nor any know-how of the internal workings of either, though I do assume that you heard of them and know what Linux and Nix are in it's most basic form. If you are already on NixOS and are struggling or are an experienced user and you're looking for a way to introduce your friends to Nix, then this guide is also for you.

### Why Nix?

One of the biggest question about ***Nix*** is why everyone who uses it praises it like some religious icon, but to answer your, you firstly need to understand what exactly ***Nix*** is, because "***Nix***" is actually three things: A package manager and repository (Nixpkgs), a programming language (NixLang), and a Linux distribution (NixOS).

![Nix-holy-trinity.png](https://media.hachyderm.io/media_attachments/files/111/071/129/711/481/861/original/cb247e197294b62a.png)

Nix, *the Linux distribution*, is really just the implementation of Nix, *the package manager*, on a larger scale, using Nix, *the programming language*, to configure the entire system, giving you the full ***Nix*** experience. So what is it that the ***Nix*** experience provides that can make even the most jumpy distro hopper settle down? It can become quite evident by going over the features nix provides:

- ***No dependency hell***. Each package is built in isolation and has it's own dependencies.  When a package needs a new dependency, it simply gets rebuild with a symlink to the new dependency. No packages are removed. Any shared dependencies are just symlinks to the specific program, so no space is wasted.

- ***Plenty of packages***. The nixpkgs repository is the largest package repository in the world, having over a 100'000 packages. You won't ever have to look at another package manager again!

- ***Stable***. The stability of a package manager really boils down to two things: Whether or not its is running ustable/experimental builds of packages and how well the dependency conflicts are handled. Since Nix eliminates the latter, all you have to do to run a stable system is to use the stable channel that only uses verified working packages and Nix takes care of the rest.

- ***Bleeding edge***. The nixpkgs-unstable is a rolling release channel that sports the most up-to-date packages in the Linux world, making sure you have access to the newest packages of everything. With flakes you can run both the stable and the unstable channels at the same time allowing you to use the stable for programs that cannot break and the unstable for programs that need the newest updates.

- ***Atomic upgrades***. Updates in Nix either happen fully, or not at all. With each package being uniquely identified by their hash, new ones don't override old ones, so if something goes wrong during an update you aren't left with a broken system.

- ***Configuration files***. The entirety of your system is configured through configuration files making managing your system incredibly easy and everything you do is self documenting, so no need to look up those commands you always forget, just read your code.

- ***Reproducible***. Since everything about your system is stored in a single git repository, sharing your system with others is as easy as sending them zip file or a link to a remote repository. And with flakes, everything is guaranteed to be an exact replication, down to the exact commit of each package.

- ***Rollbacks***. With Nix you can rollback to previous configurations, meaning that if an update contains a broken package or an experimental change you don't like, you can just revert to the state before the update as if it never happened.

- ***Dynamic environments***. Nix gives you access to the Nix shell which is an environment where you can specify whatever packages you want and use them for the duration of the shell. If you have Python3.x on your system, but for a specific task you need Python3.y, then all you have to do is initiate a shell with Python3.y and it will be gone when you leave the shell.

- ***Purely functional***. Nix is a declarative, purely functional language. This means that functions have no effect on external state. This may take some time getting used to, but it allows the interpreter to make a whole bunch of assumptions which is the key to its reproducible nature. This also forces you into a pattern that rarely produces bugs, keeping your system stable.

- ***Lazily evaluated***. Nix only evaluates values if they are called. Any errors like divisions by zero and anything that would take eons to compute is not calculated unless it is needed. You don't pay for what you don't use.

With a feature set like this it can be hard to not see the appeal.


# Nix basics

##### Types

Integers

Booleans

Nulls

Strings

Paths

Lists

Attribute sets

##### Operators

`+`

`-`

`/`

`*`

`++`

`attribute-set.attribute`

`//`


##### Other

let - in

if - else

with

inherit

brackets ( )

##### Functions

Arguments

Recursion

Libraries


# Terminal navigation

Before you go any further, it is best to get a bit more familiar with the terminal, as to not get lost when trying to navigate your system 

### File managers - Yazi

Yazi is a very advanced, batteries included terminal file manager. A good terminal file manager can change the terminal experience from tedious to blissful. Since all a Unix system is is files and directories (not really), having a good way to navigate files is a must

Yazi comes with tons of integrations with modern terminal utils like zoxide and fzf. It even has image previews (provided that your terminal environment supports it).

You can press `o` to open files with their default method (edit, unzip, view, etc), `.` to show hidden files, `a` to create files (if it ends in `/` the it becomes a directory), `r` to rename files, `Space` to toggle select files, `y`, `p` and `x` to yank (copy), paste and cut respectively, with the capital versions `Y` and `X` undoing their selections. `q` is to quit.

### Text editors - Helix

Helix, a "post-modern modal text editor", is a great terminal text editor for beginners and power-users alike. With it being a 'modal' text editor, it has modes. When you open Helix it starts on `NORMAL` mode, where you can do many things such as use `x` to select lines, `d` to delete under the cursor or the current selection, `o` and `O` to create new lines below and above respectively, `Space` then `f` to open the file picker fuzzy finder and many more.

Helix has many modes, but the most important on is of course `INSERT` mode. you can enter it by pressing `i` or `a` to insert or append the current character, or with `I` or `A` to got to the start or the end of the current line.

To exit, press `Escape`  to go back to `NORMAL` mode and the hit `:` to start a command at the bottom line. The command to exit is `:q`, short for `:quit`. To save changes `:w`, short for `:write` writes the current changes to the file. If you need to exit without saving changes then use`:q!`. To save and exit `:wq` or `:x` is the shorthand for `:write-quit`.

### Multiplexers - zellij

Right now you are in a Zellij session, you can see it by the text instructions at the bottom. Zellij is a terminal multiplexer program, allowing you to have multiple panes (terminal instances) making multitasking and just usage in general more easy and understandable.

press `alt`+`n` to create a new pane, you use `alt`+(`←↓↑→` or `HJKL`) to move between panes. `ctrl`+`p` goes into pane mode where you can press `x` to close the pane you are currently on. Just cycle through the modes available to see all options you can use. `ctrl`+`g` locks the interface, stopping Zellij from taking any other input, so if a program you use has conflicting keybinds, you can disable Zellij for to interact with the other program as Zellij always takes priority.

### Navigation tools

#### ls - eza

#### cd - zoxide

#### grep - ripgrep

#### fuzzy finder

### Others

#### fetch

#### btop

#### pipes


# Installation

Even if you already have a Working NixOS system it can still be valuable to read through the following section, as it goes over *Disko* and user management. Otherwise, skip to [Configuration](#configuration).

### Installing the ISO

The Default Gnome ISO that nixos.org provides is a bit of a trap. It's fine for first installations as the Calamares installer will probably be very familiar to a lot of Linux users, but for setting up NixOS, it can be a bit lacklustre as it doesn't benefit from all the advantages of Nix. Compared to [Guix](https://guix.gnu.org/), which has a very streamlined installation process and shows you your configuration file at the end to review, The Nix ISOs leave much to be desired.

So for this guide I have provided a custom ISO for you to use. It comes with many helpful utils and bash aliases to make the installation near automatic. Beware though that by downloading this ISO you are trusting that I have not bundled any malicious software with it. You can see the contents of the ISO in the `configs/ISO-image.nix` so if you do not trust me, you can use the minimal ISO provided by nixos.org and a see what each command does for yourself. by the end you will also be able to make your own ISO mage.

[Link to ISO download]()

The first thing you'll need is a USB thumb drive to flash the ISO to. You can use either [Etcher](https://etcher.balena.io/) or [Ventoy](https://www.ventoy.net/en/index.html). I recommend Ventoy, as you can have multiple ISO images on it while also storing files. This way you can download both a NixOS ISO and a Windows ISO, so if you want go back or something goes wrong, you can just boot back into Windows with out needing a second computer to redownload and flash the ISO.

### BIOS and booting

To boot from the ISO on the USB, open the power menu, Hold shift and click restart. If this doesn't work, you need to restart/turn on your computer, and hit either: `F2`, `F12` or `Delete` when the computer is booting. A splash screen image might say which one you need to press. With that you should be but into BIOS or UEFI interface.

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

This will fetch the repository from GitHub so that you can start editing your system.

### Disk partition

We'll be using Disko to declaratively partition your drive. Go to the yazi pane and navigate to `hardware/template` and open `disko.nix`. In the other pane, use:

```shell
lsblk
```

This will show available drives/devices to be used. There should be two drives; your USB you are currently booting from, and the drive you want to install NixOS onto. Find the correct drive and put it's name (`sda`, `nvme0`, `vda`) into the `device` field. example: If the name of your drive is `nvme0`(`n1`), the it should look like this:

```nix
  disko.devices.disk.main = {
  
    device = "/dev/nvme0n1";
    type = "disk";
    ...
```

The current setup should be fine for most. But if you want swap with hibernation then change `resumeDevice` to be `true` and set the swap size to about the size of your RAM + the square root of your RAM. Example: with 16GB of RAM, your hibernate swap should be 20GB (16 + 4). We will go more in depth on partitioning on the second remote install, so don't worry to much about setting up your partitions. 

When you're done setting up your drive exit by going into normal mode with escape, then `:wq` and enter to write and quit. Now in the command panel type:

```
mount-disko
```

This will take a short while, but if it fails for whatever reason, try fiddling with the size of the swap (like seting it to 9GB instead of 8GB).

Now you need to run a provided alias that generates a config for your system's hardware. After it is done running, the repository will be moved to `/mnt/etc/nixos`, so go to your Yazi pane and go there. The command is:

```
generate-config
```

### Host configuration

You'll need to decide on a hostname for your system. It can be anything, but best to make it something that is connected to its actual name or physical structure, for example; if you have Lenovo Yoga Slim 7, the hostname could be `slim7`, or if your computer's case is a fractal north terra the hostname could be `fn-terra`. 

Once you've done that open the flake.nix file at the root of the repository and scroll down to here:

```nix
  /* These are example configurations provided to begin using flakes.
  Rename each configuration to the hostnanme of the hardware each uses */
  nixosConfigurations = {

   #==<< Template configuration >>=============================================>
    YOUR_HOSTNAME = nixpkgs.lib.nixosSystem {
      modules = [ ./configs/template.nix ];
      specialArgs = {
        hostname = "YOUR_HOSTNAME";
        inherit inputs pa umport makeUsers recursiveMerge; };};
```

Here you need to change all `YOUR_HOSTNAME`'s to the hostname you want. Then `:wq` to save. Next type `syy` to open yazi with sudo privileges and navigate to `hardware` directory and then rename the `template` directory to your hostname.

### Users & passwords

Now decide on an username and a displayname. The username will be the one used to refer to your user in everything is is your actual username, It can't be uppercase or contain any spaces. Your displayname is what is shown when selecting users in the display manager (log-in screen) and can contain spaces and any characters.

Once you have decided, go to the `users` directory and open the example-user.nix file.

```nix
let example-user = {
  #your username
  un = "example-user";
  #your displayname
  dn = "Example User";
};
in example-user
```

Now change ALL mentions of `example-user` with your username, and then the `dn` (displayname) variable to your desired displayname and the save and exit. Now press `a` inside yazi to rename the file to your username.

Now go to the `configs` directory and open the `template.nix` and go here:

```nix
 #====<< User management >>====================================================>
  users.mutableUsers = true;   # Makes usergroups and passwords changeable.
  users.users = let
    t1 = makeUsers { # tier 1
      userlist  = [ "YOU-USERNAME" ]; 
      userrules = [ "wheel" "networkmanager" ]; };
  in recursiveMerge [ t1 t2 ];
```

Change `"YOUR-USERNAME"` to your username (in quotations).

### Localization

Now scroll down to here:

```nix
 #====<< Localization & internationalization >>================================>
  time.timeZone = "Atlantic/Reykjavik";
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

### Booting and initial setup

Now you should be able to initialize the installation. First you need to add all files to be tracked by git with:

```shell
sudo git add .
```

And with that you can now start the installation with:

```shell
nixos-install --flake .#YOUR_HOSTNAME
```

If you get any errors, read the middle line where the error is actually displayed and trace the file destination (usually down at the bottom), but remember to add all changes to git before trying to install again. If everything want well, you will have to wait for a long time as it download all necessary programs and builds them.

Once that is done you will be prompted to set a new root password. "root" is basically just a user that is assigned to your computer, so really just ***The*** admin user. You will rarely ever be prompted to use this password, maybe never, but it is the key to your system so **don't forget it**.

After that is done simply type `reboot` and hit enter.

### Home manager bootstrapping

Once you've booted into your system and logged in to your user account open any terminal emulator (Alacritty for example) and type in the following:

```
home-install
```

Most likely you will receive an error message. Don't worry, simply log in and out again and execute the command again (just press the up arrow to cycle through recent commands).

Why this fails is because of how NixOS manages shells, but this is just bootstrapping Home-manager to your system for it to be able to manage itself, so you'll never have to use this command again.

Now use the bellow command to fetch the home-manager template I have provided.

```
get-home
```

The use Yazi to navigate to the new repository and open the flake.nix file there. The only thing you have to do is go down to the `let ... in` block and change the `username` variable to your username, save and exit and then run:

```
home-switch
```

Now you'll have to log out one last time so that the changes can apply. The Home-manager configuration you are using has a fish shell that is started at every interactive shell so the problem of having to log out and in again should be fixed, but that doesn't matter now as we won't go over Home-manager until three chapters from now, where we'll explain what problem was being "fixed".

# Git basics

With everything being configured and controlled through text files, you may have realised that storing/backing-up your system can be easy and space efficient. You might have also noticed that when you revert to a previous configuration, your configuration files don't revert to the state of the current configuration, so in order to build upon your previous working configuration, you'll need to remember what was changed and revert to that state manually. This is not realistically achievable for any normal person, and so we need better solution to manage the versions of our configuration files.

### Git Version control

Git is a software version-control program. This means that it keeps track of files and any changes made to them. It takes snapshots of your repository when you make a commit allowing you to revert to that state of if you make any breaking changes. These snapshot also only keep the changes made each commit, so it stores no unnecessary information. Git also supports multiple *branching* development environments, allowing for different features to be made and tested in separate commits, which can be eventually be merged allowing all features to be pushed without conflict, even if all branches made changes to the same file as long as no one line was altered in two different ways.

Since Git is a *software* version control program, it is perfect for your configuration files. After all, Nix is a programming language, and your configuration files all amount to a small program. The way in which NixOS is used is also similar to 'code as infrastructure', so while you may not find configuring your system to be all to similar to "actual" programming, the skills you gain from Nix are all transferable to any programming environment.

### Initialising a Git repository

The repository you downloaded (this repository) has its own git directory named `git`. You can't see it as it's name starts with a dot, making it a hidden file. to see, you can use `ls -a`, `eza -a` or you can press `.` while in `yazi` to display all hidden files. Since you are here to learn git, you're going to delete the current repository and initialise a new one. In your terminal, put the following: `rm -r .git`, then use `git init`.

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

There are many ways to do this, including hosting your own server, but for most people, it's best to use some established git hoster, like GitHub or GitLabs. If you want to use any of them, simply go to those sites and look for how to make a new repository. Once that's done you can use  `git remote add <name> <url>` to add that repository as a remote.

Once you have a remote repository, you can use `git push` to push all changes you've made to the remote repository. `git fetch` fetches all changes from the remote, for if you have made any changes on another machine or on the site itself. `git pull` fetches all changes from the remote and automatically merges them (beware of any possible merge conflicts). On a new machine you can use `git clone url` to copy the repository to the new machine.

### More documentation

This should be well enough for most everything you will need to do with git. There are some more things such as notes and tags, advanced shortcut commands and some general concepts on how version control works under the hood, but for now this should suffice. If you ever need to learn anything more, simply checkout the [git documentation](https://git-scm.com/docs/git) or just search up a git cheat sheet if you need a refresher on available commands.

# Windows virtual machine
# OpenSSH