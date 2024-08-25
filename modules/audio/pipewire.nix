{ pkgs, lib, config, ... }:

with lib;
let
  cnfg = config.pipewire;
in {

  options.pipewire.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf cnfg.enable { 

    #sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };
  };

}
