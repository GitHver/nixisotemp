# Installation ISO

> [!IMPORTANT]
> If you already have a working nix config, simply edit the files according to instructions and then build the repository and skip to the [Configuration](#configuration) chapter.

### Installing the ISO

For this guide I have provided a custom ISO for you to use. It comes with many helpful utils and bash aliases to make the installation near automatic. Beware though that by downloading this ISO you are trusting that I have not bundled any malicious software with it. You can see the contents of the ISO in the `hardware/ISO-image.nix` so if you do not trust me, you can use the minimal ISO provided by nixos.org and a see what each command does for yourself. by the end you will also be able to make your own ISO mage.

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

When you see packets being sent, hit `ctrl`+`c` to stop pinging. Next, type:

```
get-repo
```

This is just an alias to `git clone` the repository from GItHub so that you don't have to type out the url yourself.

### Disk partition

We'll be using Disko to declaratively partition your drive. Use:

```shell
lsblk
```

This will show available drives/devices to be used. There should be two drives; your USB you are currently booting from, and the drive you want to install NixOS onto. Find the correct drive (`sd`, `nvme`, `vd`) and navigate to `hardware/template` and open `disko.nix`. Put the name of your drive into the `device` field. example: If the name of your drive is `sda`, then it should look like this:

```nix
  disko.devices.disk = {
    main = {
      device = "/dev/sda";
      type = "disk";
      #...
```

> [!CAUTION]
> Make sure you have the right disk. The selected disk will be completely wiped 

The current setup is two partitions - The boot partition and a BTRFS partition with an 8GB swap file. This is ideal for most users, and we'll go more in depth on disko on the reinstall with hibernation & encryption, so just leave it as is for now. Save and exit and type: 

```
mount-disko
```

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
{ #...
  #====<< Localization & internationalization >>===============================>
  time.timeZone = "Europe/London";
  i18n.defaultLocale  = "en_US.UTF-8";  # Set default localization.
  extraLocaleSettings = "en_GB.UTF-8";  # Set other localization.
  console.keyMap = "uk";                # Sets the console keymap.
  services.xserver.xkb = {              
    layout = "gb";                # Set the keymap for Xserver.
    #variant = "colemak"          # Your preference.
    options = "caps:escape"; };   # Modification options.
    #...
```

What to do here is pretty straight forward:

- Change the `timeZone` to your timezone.
- Set the `defaultLocale` to the language you want your system to be in.
- `extraLocaleSettings` is all other locales (formating, time & date, measurements, etc).
- `console.keymap` is the keyboard layout in the terminal, like `"us"` or `"is-latin1"`
- xKeyboard, `xkb`, is your keyboard configurer.
	- `layout` is your language layout (`"gb"`, `"ru"`, `"is"`).
	- `variant` is any specific variation of that layout (`"colemak"`, `"dvorak"`).
	- `options` is keyboard behaviour. Here `caps-lock` is an additional `escape`
	- These options are all mapped to the xkb options. see more [here]()

Now save and exit the template file.

### NixOS install script

And with that you can now start the installation with:

```shell
sudo nixos-install --flake .#<your-hostname>
```

After it is done evaluating the configuration you will be asked if you want to trust cache substituters for your packages. These are ditributers of pre-built binaries so that you don't have to compile everything yourself. If you want to compile the packages yourself, just press `n`, but *beware* that it could take you up to **10** hours depending on your hardware and connection.

> [!IMPORTANT]
> if you're having trouble with having to compile many packages even with the substituters, try `nix flake update` to bring your `.lock` file to the newest commit.

> [!NOTE]
> Since you are on a live medium, no preferences will carry over to your installed system, so you will be asked this question once more when you rebuld for the first time on your new system

Once that is done you will be prompted to set a new root password. "root" is basically just a user that is assigned to your system, so really just ***The*** admin user. You will rarely ever be prompted to use this password, maybe even never, but it is the key to your system so **don't forget it**. After that is done simply type `reboot` and hit enter.

### Initial setup

Once you've booted into your system log into your user account, the password is `Null&Nix1312`. Open your terminal emulator (like Alacritty for example) and change your password by typing in the following:

```shell
passwd
```

If you are on wifi you'll have to reconnect. You can either use `nmcli` again or use your desktops GUI, probably in the panel in the top right corner.

### Home manager bootstrapping

> [!NOTE]
> If you plan on using other means of dotfiles management, you might want to skip this step. However, home-manager can be used as a dotfiles symlinker, so migrating your configs is as easy as copying your dotfile directory into the `~/.config/home-manager/dotfiles` directory.

Now to install home-manager, so that you can manage user packages and configs without sudo privileges or affecting the system in any way. Use the following command to initialise a home manager repo:

```
home-get
```

This will clone the repository and open the flake.nix file there. The only thing you have to do is go down to the `let ... in` block and change the `username` and `email` variables to their correct values, save and exit and then run:

```
home-install
```

Now you can use `Super`+`D` to open Fuzzel to launch applications.
