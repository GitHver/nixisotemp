{ pkgs
, lib
, config
, ...
}:

let
  inherit (lib) mkOption mkIf types;
  name = "wayland-extras";
  cfg = config.services.${name};
in {

  options.services.${name}.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    programs.xwayland.enable = true; # For running X11 applications
    environment.variables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wayland-utils

      cage

      xwayland-satellite
      gamescope
    ];
  };

}
