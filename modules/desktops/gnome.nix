{lib, pkgs, config, ... }:

{
 #====<< Gnome Environment >>==================================================>
  services.xserver = {
    enable = true;                      # Enable th X11 windowing system.
    displayManager.gdm.enable = true;   # Use the Gnome Display Manager.
    displayManager.gdm.wayland = true;  # let GDM run on wayland.
    desktopManager.gnome.enable = true; # GNOME Desktop Environment.
  };
  services.gnome.core-utilities.enable = false; # Disables Gnome apps
  programs.dconf.enable = true;

 #====<< Excluded software >>==================================================>
  environment.gnome.excludePackages = with pkgs; [ 
    gnome-tour      # you don't need this
  ];
}
