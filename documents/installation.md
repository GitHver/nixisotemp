
# Installer walk-through

Even if you already have a Working NixOS system it can still be valuable to read through the following section, as it goes over *Disko* and user management. Otherwise, skip to [Configuration](#configuration).

### Installing the ISO

The Default Gnome ISO that nixos.org provides is a bit of a trap. It's fine for first installations as the Calamares installer will probably be very familiar to a lot of Linux users, but for setting up NixOS, it can be a bit lacklustre as it doesn't benefit from all the advantages of Nix. Compared to [Guix](https://guix.gnu.org/), which has a very streamlined installation process and shows you your configuration file at the end to review, The Nix ISOs leave much to be desired.

So for this guide I have provided a custom ISO for you to use. It comes with many helpful utils and bash aliases to make the installation near automatic. Beware though that by downloading this ISO you are trusting that I have not bundled any malicious software with it. You can see the contents of the ISO in the `configs/ISO-image.nix` so if you do not trust me, you can use the minimal ISO provided by nixos.org and a see what each command does for yourself. by the end you will also be able to make your own ISO mage.

[Link to ISO download]()

The first thing you'll need is a USB thumb drive to flash the ISO to. You can use either [Etcher](https://etcher.balena.io/) or [Ventoy](https://www.ventoy.net/en/index.html). I recommend Ventoy, as you can have multiple ISO images on it while also storing files. This way you can download both a NixOS ISO and a Windows ISO, so if you want go back or something goes wrong, you can just boot back into Windows with out needing a second computer to redownload and flash the ISO.

### BIOS and booting

To boot from the ISO on the USB, open the power menu, Hold shift and click restart. If this doesn't work, you need to restart/turn on your computer, and hit either: `F2`, `F12` or `Delete` when the computer is booting. A splash screen image might say which one you need to press. With that you should be but into BIOS or UEFI interface.

there is no standard interface, so you'll have to navigate the menus yourself. But the things you need to make sure are true is:

- To disable secure boot, as it has nothing to do with security or safety.
- Make sure SATA mode is not in any RAID configuration. Set it to AHCI.
- Move the USB that you are booting from to the top of the boot priority.

Then hit `F10` to Save and exit the BIOS/UEFI environment. On boot you will be prompted to chose boot options, just hit enter to chose the default options.

### Keyboard input

Currently, changing keymaps during the installation is more of a hassle than it is worth, so you are stuck with the uk keymap. Don't worry, you will have whatever keymap you use for your language once the installation is complete. Just Search up an image of the uk layout and use it as reference to find your keys.

### Internet

The first thing you want to do is connect to the internet. If you have an Ethernet cable, use that, else your going to have to connect to wifi. To do so, type in the following:

```bash
nmcli device wifi connect "your wifi's name" password "your wifi's password"
```

It should say that you have successfully connected with to your wifi. you can test it by pinging any site, try:

```bash
ping gnu.org
```

When you see packets being sent, hit ctrl+c to stop pinging. Next, type:

```
get-repo
```

This will fetch the repository from GitHub so that you can start editing your system.

### Terminal navigation

Before you go any further, it is best to get a bit more familiar with the terminal, as to not get lost when trying to navigate your system 

##### Zellij

Right now you are in a Zellij session, you can see it by the text instructions at the bottom. Zellij is a terminal multiplexer program, allowing you to have multiple panes (terminal instances) making multitasking and just usage in general more easy and understandable.

press `alt`+`n` to create a new pane, you use `alt`+(`←↓↑→` or `HJKL`) to move between panes. `ctrl`+`p` goes into pane mode where you can press `x` to close the pane you are currently on. Just cycle through the modes available to see all options you can use. `ctrl`+`g` locks the interface, stopping Zellij from taking any other input, so if a program you use has conflicting keybinds, you can disable Zellij for to interact with the other program as Zellij always takes priority.

##### Yazi

Yazi is a very advanced, batteries included terminal file manager. A good terminal file manager can change the terminal experience from tedious to blissful. Since all a Unix system is is files and directories (not really), having a good way to navigate files is a must

Yazi comes with tons of integrations with modern terminal utils like zoxide and fzf. It even has image previews (provided that your terminal environment supports it).

You can press `o` to open files with their default method (edit, unzip, view, etc), `.` to show hidden files, `a` to create files (if it ends in `/` the it becomes a directory), `r` to rename files, `Space` to toggle select files, `y`, `p` and `x` to yank (copy), paste and cut respectively, with the capital versions `Y` and `X` undoing their selections. `q` is to quit.

##### Helix

Helix, a "post-modern modal text editor", is a great terminal text editor for beginners and power-users alike. With it being a 'modal' text editor, it has modes. When you open Helix it starts on `NORMAL` mode, where you can do many things such as use `x` to select lines, `d` to delete under the cursor or the current selection, `o` and `O` to create new lines below and above respectively, `Space` then `f` to open the file picker fuzzy finder and many more.

Helix has many modes, but the most important on is of course `INSERT` mode. you can enter it by pressing `i` or `a` to insert or append the current character, or with `I` or `A` to got to the start or the end of the current line.

To exit, press `Escape`  to go back to `NORMAL` mode and the hit `:` to start a command at the bottom line. The command to exit is `:q`, short for `:quit`. To save changes `:w`, short for `:write` writes the current changes to the file. If you need to exit without saving changes then use`:q!`. To save and exit `:wq` or `:x` is the shorthand for `:write-quit`.

##### Setup

You should start by opening a new pane in Zellij and running yazi with sudo privilegegs by typing:

```
sudo yazi
```

now you have one pane where you can navigate the repository and open files to edit and another where you can run commands

### Disk partition

We'll be using Disko to declaratively partition your drive. Go to the yazi pane and navigate to `hardware/template` and open `disko.nix`

The current setup should be fine for most. But if you want swap with hibernation then uncomment the `resumeDevice = true;` and set the swap size to about the size of your RAM + the square root of your RAM. Example: with 16GB of RAM, your hibernate swap should be 20GB (16 + 4). We will go more in depth on partitioning on the second remote install, so don't worry to much about setting up your partitions. 

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
    # your username
    un = "example-user";
    # your displayname
    dn = "Example User";
    # Your inital password, CHANGE AS SOON AS YOU BOOT!
    pw = "Null&Nix1312";
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

```
sudo git add .
```

And with that you can now start the installation with:

```
nixos-install --flake .#YOUR_HOSTNAME
```

If you get any errors, read the middle line where the error is actually displayed and trace the file destination (usually down at the bottom), but remember to add all changes to git before trying to install again. If everything want well, you will have to wait for a long time as it download all necessary programs and builds them.

Once that is done you will be prompted to set a new root password. "root" is basically just a user that is assigned to your computer, so really just ***The*** admin user. You will rarely ever be prompted to use this password, maybe never, but it is the key to your system so **don't forget it**.

After that is done simply type `reboot` and hit enter.

### Home manager bootstrapping

Once you've booted into your system and logged in to your user; open any terminal emultor (Alacritty for example) and type in the following:

```
home-install
```

Most likely you will receive an error message. Don't worry, simply log in and out again and execute the command again (just press the up arrow to cycle through recent commands).

Why this fails is because of how NixOS manages shells, but since this just bootstrapping Home-manager to your system for it to be able to manage itself, so you'll never have to use this command again.

Now use the bellow command to fetch the home-manager template i have provided.

```
get-home
```

The use Yazi to navigate to the new repository and open the flake.nix file there. The only thing you have to do is go down to the `let ... in` block and change the `username` variable to your username, save and exit and then run:

```
home-switch
```

Now you'll have to log out one last time so that the changes can apply. The Home-manager configuration you are using has a fish shell that is started at every interactive shell so the problem of having to log out and in again should be fixed, but that doesn't matter now as we won't go over Home-manager until three chapters from now, where we'll explain what problem was being "fixed".