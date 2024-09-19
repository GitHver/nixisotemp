{ pkgs, inputs, lib, hostname, ... }:

{
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

  #====<< Linux kernel options >>==============================================>
  # Uncommenting the below sets your kernel to the lates release. By default
  # the kernel is updated to the latest version deemed stable. You can also
  # select a specific version like: pkgs.linuxKernel.packages.linux_6_3;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # Swap with hibernation. run:
  # sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
  # and put the given number as the resume_offset below.
  boot.kernelParams = [ "resume_offset=533760" ];
  boot.resumeDevice = "/dev/disk/by-label/nixos";

  #====<< Hardware Options >>==================================================>
  # hardware.enableRedistributableFirmware = true;
  # hardware.enableAllFirmware = true;
  amdgpu.enable = false;
  nvidia.enable = false;

  #====<< Heavy programs >>====================================================>
  qemuvm.enable = false;       # The QEMU virtual machine.
  programs.steam-full.enable = false; # Steam module with all permissions.

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