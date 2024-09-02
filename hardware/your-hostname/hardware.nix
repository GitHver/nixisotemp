{ pkgs, inputs, alib, ... }:

let
  inherit (alib) umport;
in {

  #====<< Import all device specific modules >>================================>
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./users.nix
    inputs.disko.nixosModules.disko
    ./../${"!configs"}/default.nix
  ] ++ umport { path = ./../../modules; recursive = true; };

  #====<< Hardware Options >>==================================================>
  amdgpu.enable = false;
  nvidia.enable = false;
  qemuvm.enable = false;

  #====<< Bootloader >>========================================================>
  # Be VERY careful when changing this, Nix is unbreakable in everything except
  # in one thing: messing with the boot-loader. You don't want to leave your
  # system in an unbootable state, so make sure you know what you are doing when
  # rebuilding any changes here. Best to first use a virtual machine with:
  # $ sudo nixos-rebuild build-wm-with-bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    # efiInstallAsRemovable = true;
    splashImage = null;
  };

  #====<< Linux kernel options >>==============================================>
  # Uncommenting the below sets your kernel to the lates release. By default
  # the kernel is updated to the latest version deemed stable. You can also
  # select a specific version like: pkgs.linuxKernel.packages.linux_6_3;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.supportedFilesystems = [ "bcachefs" ];

  #====<< Luks incryption >>===================================================>
  # # if you are using encryption on your drives, you should put it here
  # # it should look something like this:
  # boot.initrd.secrets = { "/crypto_keyfile.bin" = null; };  # Setup keyfile
  # # Enable swap on luks
  # boot.initrd.luks.devices."luks-a-bunch-of-numbers-and-letters" = {
  #   device  = "/dev/disk/by-uuid/a-bunch-of-numbers-and-letters";
  #   keyFile = "/crypto_keyfile.bin";
  # };
}
