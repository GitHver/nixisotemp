{ pkgs, lib, config, ... }:

with lib;
let
  cnfg = config.wayland;
in

{
  options.wayland.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf cnfg.enable {
    programs.xwayland.enable = true;  # For running X11 applications
    environment.variables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      wl-clipboard-rs
      wayland-utils
      xwayland-satellite
      wl-gammactl
      wl-gammarelay-rs
      wlr-randr

      cage
      libsecret
      gamescope

      brightnessctl
      clightd
    ];
  };
}
