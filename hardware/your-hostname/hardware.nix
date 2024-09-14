{ pkgs, inputs, lib, hostname, ... }:

let
  inherit (lib.filesystem) listFilesRecursive;
in {

  #====<< Import all device specific modules >>================================>
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./users.nix
    inputs.disko.nixosModules.disko
    ./../configuration.nix
  ] 
  # ++ listFilesRecursive ./../../modules
  ;

  #====<< Hardware Options >>==================================================>
  # hardware.enableRedistributableFirmware = true;
  # hardware.enableAllFirmware = true;
  amdgpu.enable = false;
  nvidia.enable = false;

  #====<< Heavy programs >>====================================================>
  qemuvm.enable = false;       # The QEMU virtual machine.
  programs.steam-full.enable = false; # Steam module with all permissions.

  #====<< Linux kernel options >>==============================================>
  # Uncommenting the below sets your kernel to the lates release. By default
  # the kernel is updated to the latest version deemed stable. You can also
  # select a specific version like: pkgs.linuxKernel.packages.linux_6_3;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.supportedFilesystems = [ "bcachefs" ];
  # Swap with hibernation
  # https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Acquire_swap_file_offset
  # boot.kernelParams = [ "resume_offset=533760" ];
  # boot.resumeDevice = "/dev/disk/by-label/nixos";

  #====<< Bootloader >>========================================================>
  # Be VERY careful when changing this, Nix is unbreakable in everything except
  # in one thing: messing with the boot-loader. You don't want to leave your
  # system in an unbootable state, so make sure you know what you are doing when
  # rebuilding any changes here. Best to first use a virtual machine with:
  # $ sudo nixos-rebuild build-wm-with-bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    # efiInstallAsRemovable = true;
    splashImage = null;
  };

  #====<< Network config >>====================================================>
  bluetooth.enable = true;
  networking = {
    hostName = hostname;          # The name of your computer on the network.
    networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
    firewall = {                # If you're having trouble with connection
      enable = true;            # permissions, you can disable the firewall
      allowedTCPPorts = [ ];    # or open some ports here,
      allowedUDPPorts = [ ];    # or here.
    };
  };
}
