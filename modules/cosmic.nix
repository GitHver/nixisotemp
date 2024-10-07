{ lib
, config
, ...
}:

let
  inherit (lib) mkOption mkEnableOption;
  inherit (lib.types) str;
  cfg = config.services.cosmic;
in {

  options.services.cosmic = {
    enable = mkEnableOption "The COSMIC desktop environment";
    greeter.enable = mkEnableOption "The COSMIC display manager";
    xwayland.enable = mkEnableOption "XWayland in the COSMIC compositor";
  };

  config = {
    services = {
      desktopManager.cosmic.enable = cfg.enable;
      desktopManager.cosmic.xwayland.enable = cfg.xwayland.enable;
      displayManager.cosmic-greeter.enable = cfg.greeter.enable;
    };
  };

}
