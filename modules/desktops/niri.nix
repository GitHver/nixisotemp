{ pkgs, lib, config, inputs, ... }:

with lib;
let
  cnfg = config.niri;
in

{
  imports = [ inputs.niri.nixosModules.niri ];
  
  options.niri.enable = mkOption {
    type = types.bool;
    default = false;
    # description = "The Niri wayland compositor";
  };

  config = mkIf cnfg.enable { 

    services.xserver.enable = true;

    programs.niri.enable  = true;
    programs.niri.package = pkgs.niri-stable;
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  
  };
}
