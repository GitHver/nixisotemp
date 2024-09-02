{ pkgs
, lib
, config
, ...
}:

let
  inherit (lib) mkOption mkIf types;
  name = "lightdm";
  cfg = config.services.displayManager.${name};
in
{

  options.services.displayManager.${name}.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager.lightdm = {
      enable = true;
      background = ./../assets/loginscreen.jpg;
    };
  };
}
