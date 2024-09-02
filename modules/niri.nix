{ pkgs
, lib
, config
, inputs
, ...
}:

let
  inherit (lib) mkOption mkIf types;
  name = "niri";
  cnfg = config.${name};
in
{

  imports = [ inputs.niri.nixosModules.niri ];

  options.${name}.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cnfg.enable {
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri-stable;
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    environment.systemPackages = (with pkgs; [
      alacritty
    ]);
  };
}
