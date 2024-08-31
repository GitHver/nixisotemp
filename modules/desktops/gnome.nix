{ pkgs
, lib
, config
, ...
}:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.gnome;
in {

  options.gnome.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable { 
    #====<< Gnome Environment >>===============================================>
    services.xserver.desktopManager.gnome.enable = true; # GNOME Desktop Environment.
    services.gnome.core-utilities.enable = true; # Disables Gnome apps
    programs.dconf.enable = true;
    environment.systemPackages = (with pkgs; [
      gnome-console
    ]);
    environment.gnome.excludePackages = (with pkgs; [ 
      gnome-tour      # you don't need this
    ]);
  };
}
