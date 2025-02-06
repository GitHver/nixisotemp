{ pkgs
, lib
, config
, ...
}:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.hardware.amdgpu;
in {

  options.hardware.amdgpu.enable =
    mkEnableOption
    "AMD GPU drivers and RocM support"
  ;

  config = mkIf cfg.enable {
    #====<< AMD Drivers >>========================================================>
    nixpkgs.config.rocmSupport = true;
    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      amdvlk.enable = true;
    };
    hardware.graphics.extraPackages = with pkgs; [
      rocmPackages.rocminfo
      rocmPackages.rocm-smi
    ];
    environment.systemPackages = with pkgs; [ lact ];
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = ["multi-user.target"];
    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
    ];
  };

}
