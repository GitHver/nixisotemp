{ ... }:

{

 #====<< Steam permission enabler >>===========================================>
  programs.steam = {
    enable = true;
    # Open ports in the firewall for Steam Remoteplay
    remotePlay.openFirewall = true;
    # Open ports in the firewall for Steam server
    dedicatedServer.openFirewall = true;
  };

}

