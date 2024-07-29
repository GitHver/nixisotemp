{ pkgs, ... }:

{

 #====<< AMD Drivers >>========================================================>
  boot.initrd.kernelModules = [ "amdgpu" ];
  # Usually some other configuration...
  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages_5.rocm-runtime
    rocmPackages_5.rocminfo
    amdvlk
    rocmPackages_5.clr.icd
    rocmPackages_5.rocm-smi
  ];
  nixpkgs.config.rocmSupport = true;
  hardware.graphics = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
  };
  systemd.tmpfiles.rules = [
     "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages_5.clr}"
  ];
  # environment.systemPackages = with pkgs; [
  #   rocmPackages
  # ];

}
