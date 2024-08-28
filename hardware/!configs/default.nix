{ pkgs, alib, patt, hostname, ... }:

let
  inherit (alib) umport;
in { config = {

  #====<< Options >>===========================================================>
  gnome.enable = true;
  niri.enable  = false;
  programs.hyprland.enable = false;
  steam-client.enable = false;

  #=====<< Bootloader & Display manager >>=====================================>
  /* Be VERY careful when changing this, Nix is unbreakable in everything except
  in one thing: messing with the boot-loader. You don't want to leave your
  system in an unbootable state, so make sure you know what you are doing when
  rebuilding any changes here. Best to first use a virtual machine or a
  "throw-away"/secondary computer. */
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  services.xserver.displayManager.lightdm.enable = true;

  #====<< Desktop >>===========================================================>
  services.xserver.enable = true;
  services.xserver.exportConfiguration = true;  

  #====<< Network config >>====================================================>
  networking = {
    hostName = hostname;     # The name of your computer.
    networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
    #wireless.enable = true;      # Unneccesary, Comes packaged with most DEs.
    firewall = {                    # If you're having trouble with connection
      enable = true;                # permissions, you can disable the firewall
      #allowedTCPPorts = [ ... ];   # or open some ports here
      #allowedUDPPorts = [ ... ];   # or here.
      };};
  services.openssh.enable = false;

  #====<< Localization & internationalization >>===============================>
  time.timeZone = "Atlantic/Reykjavik";
  i18n.defaultLocale  = "en_GB.UTF-8";  # Set default localization.
  extraLocaleSettings = "is_IS.UTF-8";  # Set main localization.
  console.keyMap = "is-latin1";         # Sets the console keymap.
  services.xserver.xkb = {              
    layout = "is";                # Set the keymap for Xserver.
    options = "caps:escape";      # Modification options.
  };

  #====<< Nix specific settings >>=============================================>
  system.stateVersion = "24.11";              # What version of Nix to use
  programs.nix-ld.enable = true;              # Nix-ld is mostly for developers.
  programs.nix-ld.libraries = with pkgs; [];  # doesn't hurt to have it though!
  nix.settings = {
    allowed-users = [ "root" "@wheel" "@nixers" ];  # Note: the wheel group is for admins.
    trusted-users = [ "root" "@wheel" "@nixers" ];
    experimental-features = [ "flakes" "nix-command" ];
  };

  #====<< System packages >>===================================================>
  services.flatpak.enable = false;       # See "flatpaks" for more info.
  # Below is where all the sytem-wide packages are installed.
  # Go to https://search.nixos.org/packages to search for programs.
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    #==<< Programs >>==================>
    micro
    btop
    alacritty
    kitty
    cachix
    git       # Best learn to use git. it *WILL* make your life easier.
  ];

  #====<< Miscellaneous >>=====================================================>
  xdg.portal.enable = true;         # XDG Desktop portal (for nix and flatpaks)
  services.printing.enable = true;  # Printer protocols
  # programs.light.brightnessKeys = {
  #   enable = true;
  #   step  = 5;
  # };

};} ################ End of variable & config scope. ###########################
