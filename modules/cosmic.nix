{ pkgs
, lib
, config
, ...
}:

let
  inherit (lib) mkOption mkEnableOption mkIf;
  inherit (lib.types) str bool;
  cfg = config.services.cosmic;
in {

  options.services.cosmic = {
    enable = mkEnableOption "The COSMIC desktop environment";
    greeter.enable = mkEnableOption "The COSMIC display manager";
    xwayland.enable = mkEnableOption "XWayland in the COSMIC compositor";
    useGnomeUtils = mkOption {
      type = bool;
      default = true;
      description = "GNOME utils to fill in uses not yet covered by COSMIC";
    };
  };

  config = {
    services = {
      desktopManager.cosmic.enable = cfg.enable;
      desktopManager.cosmic.xwayland.enable = cfg.xwayland.enable;
      displayManager.cosmic-greeter.enable = cfg.greeter.enable;
    };
    environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = mkIf cfg.enable 1;
    environment.systemPackages = mkIf cfg.useGnomeUtils (with pkgs; [
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
  };

}
