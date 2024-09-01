{ pkgs
, lib
, config
, ...
}:

let
  inherit (lib) mkOption mkIf types;
  name = "hyprland";
  cfg = config.${name};
in
{

  options.${name}.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
    services.hypridle.enable = true;
    environment.systemPackages = (with pkgs; [
      kitty
    ]);
  };
}
