{ inputs, ... }:

{

 #====<< Import all device specific modules >>=================================>
  imports = let 
    path = "../../modules/hardware";
  in [
    ./hardware-configuration.nix
    ./disko.nix
    inputs.disko.nixosModules.disko
    #./${path}amdgpu.nix    # If you have an AMD GPU
    ./${path}nvidia.nix    # or If you have an Nvidia GPU
  ];

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
