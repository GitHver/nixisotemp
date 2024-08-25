{ inputs, alib, ... }:

let
 inherit (alib) umport;
in {

 #====<< Import all device specific modules >>=================================>
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./users.nix
    inputs.disko.nixosModules.disko
    ./../${"!"}configs/default.nix
  ] ++ umport { path = ./../../modules/hardware; recursive = true; };

 #====<< Hardware Options >>===================================================>
  amdgpu.enable = false;
  nvidia.enable = false;
  qemuvm.enable = false;

 #====<< Luks incryption >>====================================================>
  # if you are using encryption on your drives, you should put it here
  # it should look something like this:
  /*
  boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };  # Setup keyfile
  # Enable swap on luks
  boot.initrd.luks.devices."luks-a-bunch-of-numbers-and-letters" = {
    device  = "/dev/disk/by-uuid/a-bunch-of-numbers-and-letters";
    keyFile = "/crypto_keyfile.bin";
  };
  */
}
