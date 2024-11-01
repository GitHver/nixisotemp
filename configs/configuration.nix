{ pkgs, lib, inputs, ... }:

let
  inherit (lib) mkDefault;
  experimental = false;
in { config = {

  #====<< System Services >>===================================================>
  services = {
    # The COSMIC desktop environment. Wayland based & Rust made.
    cosmic.enable = true;
    cosmic.xwayland.enable = true;
    cosmic.greeter.enable = true;
    # Printer protocols. Enable for support.
    printing.enable = false;
  };

  #====<< System packages >>===================================================>
  # If you want to use flatpaks for some reason, all you have to do is set the
  # option below to true and run the command: `flathub-add`.
  services.flatpak.enable = true;
  # Here you can decide if you to allow non open source packages to be installed
  # on your system. You should try to disable this and see what it says!
  nixpkgs.config.allowUnfree = mkDefault false;
  # This adds `~/.local/bin` to the PATH variable, allowing you to have a place
  # to put unpatched executables to like scripts.
  environment.localBinInPath = true;
  # Below is where all the sytem-wide packages are installed.
  # Go to https://search.nixos.org/packages to search for packages.
  environment.systemPackages = (with pkgs; [
    #==<< System management >>=========>
    mission-center      # Resource monitoring tool
    gnome-disk-utility  # Disk formatter
    # baobab              # Disk usage visualiser
    # gnome-connections   # Remote desktop connections
    gnome-logs          # System logs
    file-roller         # File extractor
    #==<< Gnome extra >>===============>
    # evince              # Document viewer
    loupe               # Image viewer
    # gnome-clocks        # Clock and timer util
    # gnome-font-viewer   # Font previewer
    # gnome-characters    # Special character and emoji selector
    gnome-calculator    # Calculator
    # simple-scan         # Printer interfacer
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
  services.xremap.config.keymap = [
    { name = "orvar";
    remap = {
      "M-h" = "LEFT";
      "M-J" = "DOWN";
      "M-K" = "UP";
      "M-L" = "RIGHT";
      "M-SHIFT-h" = "HOME";
      "M-SHIFT-J" = "PAGEDOWN";
      "M-SHIFT-K" = "PAGEUP";
      "M-SHIFT-L" = "END";
    };}
  ];

  #====<< Nix specific settings >>=============================================>
  system.stateVersion = "24.11";  # What version of NixOS configs to use.
  nix = {
    # What version of the Nix package manager to use. You can also use Lix.
    package =
      if experimental == false
      then pkgs.nix
      else pkgs.nixVersions.latest
    ;
    settings = {
      # Access rights to the Nix deamon. This is a list of users, but you can
      # specify groups by prefixing an entry with `@`. `*` is everyone.
      allowed-users = [ "*" ];
      trusted-users = [ "root" "@wheel" ];
      # These are features needed for flakes to work. You can find more at:
      # https://nix.dev/manual/nix/2.24/development/experimental-features
      experimental-features = [ "flakes" "nix-command" /*"recursive-nix"*/ ];
    };
    # For `nixd` package and option evaluation
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    # Replaces identical files with links to save space. works the same as:
    # `nix store optimise`
    settings.auto-optimise-store = true;
    # Automatically delete old & unused packages
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "--delete-older-than 7d";
  };

  #====<< Miscellaneous >>=====================================================>
  documentation.nixos.enable = false; # Removes the NixOS manual application.
  # Nix ld is one solution to the static binary problem. This only affects you
  # if you need to run random binaries from sources other than nixpkgs. Learn
  # more here: https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = (with pkgs; [ ]);

};} ###################### End of config scope. ################################
