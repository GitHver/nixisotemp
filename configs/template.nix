{ pkgs, hostname, ... }:

let
  DE = "gnome";
in

{ ############################ Variable scope ##################################

 #=====<< Module imports >>=====================================================>
  imports = [
    ./../modules/lib/userlogic.nix
    ./../modules/desktops/${DE}.nix        # The most popular desktop environment
    #./../modules/virtualization.nix
    #./../modules/steam.nix        # If you want steam remote play or need to
  ];                              # host dedicated servers, uncomment this

  config = { ################# Config scope ####################################

 #====<< User management >>====================================================>
  users.mutableUsers = true;         # Makes the home directory writeable.
  # users.users.${username} = {        # See variables at top ↑.
  #   description = "${displayname}";
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" "networkmanager" ];
  # };

 #====<< System packages >>====================================================>
  services.flatpak.enable = false;       # See "flatpaks" for more info.
  # Below is where all the sytem-wide packages are installed.
  # Go to https://search.nixos.org/packages to search for programs.
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [ 
   #==<< Terminal Programs >>==========>
    zellij    # User friendly terminal multiplexer.
    helix     # No nonsense terminal modal text editor.
    yazi      # Batteries included terminal file manager.
   #==<< Terminal utils >>=============>
    zoxide    # A better cd command that learns your habbits.
    eza       # LS but with more options ad customization.
    bat       # Better cat. Print out files in the terminal.
    starship  # Shell promt customization tool.
    btop      # Better top, a resource monitoring tool.
   #==<< Other >>======================>
    git       # Best learn to use git. it *WILL* make your life easier.
    gitui     # Git terminal user interface written in rust.
  ];

 #=====<< Bootloader >>========================================================>
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  /* Be VERY careful when changing this, nix is unbreakable in everything except
  in one thing: messing with the boot-loader. You don't want to leave your
  system in an unbootable, so make sure you know what you are doing when
  rebuilding any changes here. Best to first use a virtual machine or a
  "throw-away" computer. */

 #====<< Network config >>=====================================================>
  networking = {
    hostName = "${hostname}";     # The name of your computer.
    networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
    #wireless.enable = true;      # Unneccesary, Comes packaged with most DEs.
    firewall = {                    # If you're having trouble with connection
      enable = true;                # permissions, you can disable the firewall
      #allowedTCPPorts = [ ... ];   # or open some ports here
      #allowedUDPPorts = [ ... ];   # or here.
      };};
  services.openssh.enable = false;

 #====<< Localization & internationalization >>================================>
  time.timeZone = "Atlantic/Reykjavik";
  i18n.defaultLocale  = "en_GB.UTF-8";  # Set default localization.
  extraLocaleSettings = "is_IS.UTF-8";  # Set main localization.
  console.keyMap = "is-latin1";         # Sets the console keymap.
  services.xserver.xkb = {              
    layout = "is";                # Set the keymap for Xserver.
    variant = "";                 # Your keyboard's variation, e.x  "104-key",
  };                              # It is not required.

 #====<< Nix specific settings >>==============================================>
  system.stateVersion = "24.11";              # What version of Nix to use
  programs.nix-ld.enable = true;              # Nix-ld is mostly for developers.
  programs.nix-ld.libraries = with pkgs; [];  # doesn't hurt to have it though!
  nix.settings = {
    allowed-users = [ "root" "@wheel" ];  # Note: the wheel group is for admins.
    trusted-users = [ "root" "@wheel" ];
    experimental-features = [ "flakes" "nix-command" ];
  };

 #====<< Miscellaneous >>======================================================>
  xdg.portal.enable = true;         # XDG Desktop portal (for nix and flatpaks)
  programs.xwayland.enable = true;  # For running X11 applications
  services.printing.enable = true;  # Printer protocols
  fonts.packages = with pkgs; [     # Fonts to import
    maple-mono-NF
    (nerdfonts.override { fonts = [ # Nerd Fonts for displaying special glyphs
      "CascadiaCode"
      #"FiraCode"
    ]; })
  ];

  #programs.bash.loginShellInit = ''
  #  eval "$(zoxide init bash)"
  #  eval "$(starship init bash)"
  #  eval "$(zellij setup --generate-auto-start bash)"
  #'';

};} ################ End of variable & config scope. ###########################
