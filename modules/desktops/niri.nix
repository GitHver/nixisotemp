{ niri, pkgs, ... }:

{
    imports = [niri.nixosModules.niri];
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

}
