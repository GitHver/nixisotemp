{ lib
, config
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg =  config.programs.steam.full;
in {

  options.programs.steam.full.enable =
    mkEnableOption
    "Steam client with all permissions"
  ;

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      # Open ports in the firewall for Steam Remoteplay.
      remotePlay.openFirewall = true;
      # Open ports in the firewall for Steam server.
      dedicatedServer.openFirewall = true;
      # Opens ports to allow file (game) transfers on your local network.
      localNetworkGameTransfers.openFirewall = true;
      # Valve's micro compositor. Runs inside your primary compositor.
      gamescopeSession.enable = true;
    };
  };

}

