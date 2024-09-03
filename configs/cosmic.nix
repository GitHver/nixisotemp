{ pkgs, inputs, alib, patt, hostname, ... }:

let
  inherit (patt) pkgs-stable;
in
{ config = {

  #====<< Desktop >>===========================================================>
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;
  services.desktopManager.cosmic.apps-excl = true;

  #====<< Network config >>====================================================>
  networking = {
    hostName = hostname;          # The name of your computer on the network.
    networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
    #wireless.enable = true;      # Unneccesary, Comes packaged with most DEs.
    firewall = {                    # If you're having trouble with connection
      enable = true;                # permissions, you can disable the firewall
      #allowedTCPPorts = [ ... ];   # or open some ports here,
      #allowedUDPPorts = [ ... ];   # or here.
    };
  };

  #====<< Localization & internationalization >>===============================>
  time.timeZone = "Atlantic/Reykjavik";
  i18n.defaultLocale = "en_GB.UTF-8";   # Set default localization.
  extraLocaleSettings = "is_IS.UTF-8";  # Set main localization.
  console.keyMap = "is-latin1";         # Sets the console keymap.
  services.xserver.xkb = {
    layout = "is";            # Set the keymap for Xserver.
    options = "caps:escape";  # Modification options.
  };

  #====<< Nix specific settings >>=============================================>
  system.stateVersion = "24.11"; # What version of NixOS configs to use.
  programs.nix-ld.enable = true; # Nix-ld is mostly for developers.
  programs.nix-ld.libraries = with pkgs; [ ]; # doesn't hurt to have it though!
  nix.settings = {
    allowed-users = [ "root" "@wheel" ]; # Note: the wheel group is for admins.
    trusted-users = [ "root" "@wheel" ];
    experimental-features = [ "flakes" "nix-command" ];
  };

  #====<< System packages >>===================================================>
  services.flatpak.enable = false; # See "flatpaks" for more info.
  # Below is where all the sytem-wide packages are installed.
  # Go to https://search.nixos.org/packages to search for programs.
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = (with pkgs; [
    #==<< Programs >>==================>
    btop        # Terminal resource monitoring tool
    git         # Best learn to use git. it *WILL* make your life easier.
  ]) ++ (with pkgs-stable; [ ]); # packages to use the stable channel.

  #====<< Miscellaneous >>=====================================================>
  xdg.portal.enable = true;         # XDG Desktop portal.
  services.printing.enable = true;  # Printer protocols.

};} ################ End of variable & config scope. ###########################
