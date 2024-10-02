{ pkgs, ... }:

{ config = {

  #====<< System Services >>===================================================>
  services = {
    # The COSMIC desktop environment. Wayland based & Rust made.
    displayManager.cosmic-greeter.enable = true;
    desktopManager.cosmic.enable = true;
    # Extra utils for wayland like `cage` and `wl-clipboard`.
    wayland-extras.enable = true;
    # Full sound support.
    pipewire.full = true;
  };

  #====<< System packages >>===================================================>
  # If you want to use flatpaks for some reason, all you have to do is set the
  # option below to true and run the command: `flathub-add`.
  services.flatpak.enable = false;
  # Here you can decide if you to allow non open source packages to be installed
  # on your system. You should try to disable this and see what it says!
  nixpkgs.config.allowUnfree = true;
  # Below is where all the sytem-wide packages are installed.
  # Go to https://search.nixos.org/packages to search for programs.
  environment.systemPackages = (with pkgs; [
    #==<< Programs >>==================>
    git         # Best learn to use git. it *WILL* make your life easier.
    btop        # Terminal resource monitoring tool
  ]);

  #====<< Localization & internationalization >>===============================>
  localization = {
    # i18n locale. You can find available locales with `locale -a`.
    language   = "en_AU" + ".UTF-8";
    formatting = "is_IS" + ".UTF-8";
    # Your time zone. See all available with `timedatectl list-timezones`.
    timezone   = "Atlantic/Reykjavik";
  };

  #====<< Keyboard >>==========================================================>
  console.useXkbConfig = true;  # Makes the virtual terminal use the xkb config.
  services.xserver.xkb = {
    layout  = "is";           # Set the language keymap for XKeyboard.
    variant = "";             # Any special layout you use like colemak, dvorak.
    model   = "pc104";        # The keyboard model. default is 104 key.
    options = "caps:escape";  # Here, Capslock is an additional escape key. 
  };

  #====<< Nix specific settings >>=============================================>
  system.stateVersion = "24.11";  # What version of NixOS configs to use.
  # Here you can specify the version of Nix you want to use. The current
  # stable is `2.18.x`. You can also use Lix instead.
  nix.package = pkgs.nixVersions.latest;
  nix.settings = {
    # Access rights to the Nix deamon. This is a list of users, but you can
    # specify groups by prefixing an entry with `@`. `*` is everyone.
    allowed-users = [ "*" ];
    trusted-users = [ "root" "@wheel" ];
    # These are features needed for flakes to work. You can find more at:
    # https://nix.dev/manual/nix/2.24/development/experimental-features
    experimental-features = [ "flakes" "nix-command" ];
    # Replaces identical files with links to save space. works the same as:
    # `nix store optimise`
    auto-optimise-store = true;
  };
  # Automatically delete old & unused packages.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  #====<< Miscellaneous >>=====================================================>
  # xdg.portal.enable = true; # XDG Desktop portal (for nix and flatpaks).
  documentation.nixos.enable = false; # Removes the NixOS manual application.
  services.printing.enable = false;   # Printer protocols. Enable for support.
  # Nix ld is one solution to the static binary problem. This only affects you
  # if you need to run random binaries from sources other than nixpkgs. Learn
  # more here: https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = (with pkgs; [ ]);

};} ###################### End of config scope. ################################

    # The GNOME desktop environment. The most popular to date. 
    # desktopManager.gnome.enable = true;
    # The XServer. Soon to be deprecated.
    # xserver = {
    #   enable = true;
    #   excludePackages = [ pkgs.xterm ];
    # };
    # libinput.enable = true;
