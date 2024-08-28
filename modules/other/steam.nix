{ lib, config, ... }:

with lib;
let
  cnfg = config.steam-client;
in

{
  options.steam-client.enable = mkOption {
    type = types.bool;
    default = false;
    #description = "Steam client and permissions";
  };

  config = mkIf cnfg.enable { 
    programs.steam = {
      enable = true;
      # Open ports in the firewall for Steam Remoteplay
      remotePlay.openFirewall = true;
      # Open ports in the firewall for Steam server
      dedicatedServer.openFirewall = true;
      # For better game tuning
      gamescopeSession.enable = true;
    };
  };
}

