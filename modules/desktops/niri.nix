{ pkgs, lib, config, niri, ... }:

with lib;
let
  cnfg = config.niri;
in

{
  imports = [ niri.nixosModules.niri ];
  
  options.niri.enable = mkOption {
    type = types.bool;
    default = false;
    # description = "The Niri wayland compositor";
  };

  config = mkIf cnfg.enable { 

    #imports = [ niri.nixosModules.niri ];

    services.xserver.enable = true;
  
    programs.niri.enable = true;
    nixpkgs.overlays = [niri.overlays.niri];
    programs.niri.package = pkgs.niri-stable;
    # programs.niri.package = pkgs.niri-unstable.override {src = niri-working-tree;};
  
    environment.variables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      wl-clipboard
      wayland-utils
      rofi-wayland
      waybar
      libsecret
      cage
      gamescope
    ];
      # qt.enable = true;
      # qt.style = "adwaita-dark";
      # qt.platformTheme = "gnome";
  };
}
