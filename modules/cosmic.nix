{ pkgs
, lib
, config
, inputs
, ...
}:

let
  inherit (lib) mkOption mkIf types;
  # name = services.desktopManager.cosmic.cachix;
  cfg = config.services.desktopManager.cosmic.apps-excl;
in
{

  imports = [ inputs.nixos-cosmic.nixosModules.default ];

  options.services.desktopManager.cosmic.apps-excl.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkIf cfg.enable {
    environment.cosmic.excludePackages = (with pkgs; [
      cosmic-applets
      cosmic-applibrary
      cosmic-bg
      cosmic-edit
      cosmic-files
      # cosmic-greeter
      cosmic-icons
      cosmic-launcher
      cosmic-notifications
      cosmic-osd
      cosmic-panel
      # cosmic-randr
      cosmic-screenshot
      # cosmic-session
      cosmic-settings
      cosmic-settings-daemon
      cosmic-term
      cosmic-workspaces-epoch
      hicolor-icon-theme
      playerctl
      pop-icon-theme
      # pop-launcher
    ]);
  };
}
