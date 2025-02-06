{ pkgs
, lib
, ... 
}:

let
  port = 22256;
in {

  services.minecraft-server = {
    enable = true;
    eula = true;
    declarative = true;
    serverProperties = {
      difficulty = "hard";
      gamemode = "survival";
      simulation-distance = 12;
      view-distance = 32;
      "querry.port" = port;
      server-port = port;
    };
    jvmOpts = "-Xms4092M -Xmx12276M";
  };

  #====<< Network config >>====================================================>
  networking.firewall = {
    allowedTCPPorts = [ port ];
    allowedUDPPorts = [ port ];
  };

}
