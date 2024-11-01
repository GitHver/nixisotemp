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
    "AMD GPU drivers and RocM support";

  config = mkIf cfg.enable {
    #====<< AMD Drivers >>========================================================>
    boot.initrd.kernelModules = [ "amdgpu" ];
    hardware.graphics.enable = true;
    # hardware.graphics.extraPackages = with pkgs; [
    #   rocmPackages_5.rocm-runtime
    #   rocmPackages_5.rocminfo
    #   amdvlk
    #   rocmPackages_5.clr.icd
    #   rocmPackages_5.rocm-smi
    # ];
    # nixpkgs.config.rocmSupport = true;
    # systemd.tmpfiles.rules = [
    #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
    # ];
    # environment.systemPackages = with pkgs; [
    #   rocmPackages
    # ];
    # hardware.graphics = {
    #   enable = true;
    #   #driSupport = true;
    #   #driSupport32Bit = true;
    # };
  };

}
