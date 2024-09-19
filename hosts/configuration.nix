{ pkgs, ...}:

{ config = {

  #====<< System Services >>===================================================>
  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
    pipewire.full = true;
    # desktopManager.gnome.enable = true;
    # libinput.enable = true;
    # xserver = {
    #   enable = true;
    #   excludePackages = [ pkgs.xterm ];
    # };
  };

  #====<< System packages >>===================================================>
  services.flatpak.enable = false; # See "flatpaks" for more info.
  # Below is where all the sytem-wide packages are installed.
  # Go to https://search.nixos.org/packages to search for programs.
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = (with pkgs; [
    #==<< Programs >>==================>
    # alacritty   # Fast terminal emulator writen in rust
    btop        # Terminal resource monitoring tool
    git         # Best learn to use git. it *WILL* make your life easier.
  ]); 
  # ++ (with pkgs-stable; [ ]); # packages to use the stable channel.

  #====<< Localization & internationalization >>===============================>
  localization = {
    language   = "en_GB";
    formatting = "is_IS";
    timezone   = "Atlantic/Reykjavik";
  };

  #====<< Keyboard >>==========================================================>
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout  = "is";           # Set the language keymap for XKeyboard.
    variant = "";             # Any special layout you use like colemak, dvorak.
    model   = "pc104";        # The keyboard model. default is 104 key.
    options = "caps:escape";  # Here, Capslock is an additional escape key. 
  };

  #====<< Nix specific settings >>=============================================>
  system.stateVersion = "24.11"; # What version of NixOS configs to use.
  programs.nix-ld.enable = true;              # Nix-ld is for dynamically
  programs.nix-ld.libraries = with pkgs; [ ]; # linked libraries.
  nix.channel.enable = false;
  nix.settings = {
    allowed-users = [ "*" ];  # This is the default, all users allowed.
    trusted-users = [ "root" "@wheel" ];  # `@` denotes a group.
    experimental-features = [ "flakes" "nix-command" ];
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  #====<< Miscellaneous >>=====================================================>
  xdg.portal.enable = true; # XDG Desktop portal (for nix and flatpaks).
  services.printing.enable = true; # Printer protocols.

};} ################ End of variable & config scope. ###########################
