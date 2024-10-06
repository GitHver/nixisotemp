{ pkgs, host, ... }:

let
  consolefontsize = "32";
  grubfontsize = consolefontsize;
in {

  #====<< Imported files >>====================================================>
  imports = [
    ./accounts.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./../configuration.nix
  ];

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
    font = "${pkgs.terminus_font}/share/fonts/terminus/ter-u${grubfontsize}b.otb";
    splashImage = null; # Removes the NixOS logo image.
  };
  console = {
    earlySetup = true;
    font = "ter-i${consolefontsize}b";
    packages = [ pkgs.terminus_font ];
  };

  #====<< Linux kernel options >>==============================================>
  boot = {
    # By default the kernel is updated to the latest version deemed stable. Here
    # it is set to the latest release. Uncomment the line below to go use the
    # stable kernel. You can also select a specific version of the kernel like:
    # `pkgs.linuxKernel.kernels.linux_6_1`
    kernelPackages = pkgs.linuxPackages_latest;
    # Hibernation. run: `swap-offset` and put the number as the resume_offset.
    # kernelParams = [ "resume_offset=533760" ];
    # resumeDevice = "/dev/disk/by-label/nixos";
    # initrd.systemd.enable = true;
  };

  #====<< Hardware Options >>==================================================>
  hardware = {
    enableRedistributableFirmware = false;
    enableAllFirmware = false;
    amdgpu.enable = false;
    nvidia.enable = false;
  };

  #====<< Heavy / privileged programs >>=======================================>
  programs = {
    qemuvm.enable = false;     # The QEMU virtual machine.
    steam.full.enable = false; # Steam module with all permissions.
  };

  #====<< Network config >>====================================================>
  networking = {
    hostName = host;          # The name of your computer on the network.
    networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
    firewall = {                # If you're having trouble with connection
      enable = true;            # permissions, you can disable the firewall
      allowedTCPPorts = [ ];    # or open some ports here,
      allowedUDPPorts = [ ];    # or here.
    };
  };
}

      # font = "${pkgs.tamzen}/share/fonts/misc/Tamzen10x20r.otb"; # (pf2/otb/ttf) Invalid font breaks TTY resolution
      # fontSize = 30; # Size should match bitmap font size
      # gfxpayloadEfi = "3840x1600x32"; # TTY resolution (grub > videoinfo)
      # gfxmodeEfi = "auto"; # Grub resolution (overridden by console mode)
      # extraConfig = "
      #   terminal_input console
      #   terminal_output console
      # ";
    # # Systemd boot is a simple bootloader with minimal configuration.
    # systemd-boot = {
    #   enable = false;
    #   editor = false;
    #   consoleMode = "max";
    #   configurationLimit = 30;
    #   # netbootxyz.enable = true;
    #   # memtest86.enable = true;
    # };
    # Menu settings
    # memtest86.enable = true;
