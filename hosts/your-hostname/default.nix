{ pkgs, host, ... }: {

  #====<< Imported files >>====================================================>
  imports = [
    ./accounts.nix
    ./disko.nix
    ./hardware-configuration.nix
    ./../../configs/configuration.nix
    ./../../configs/keymap.nix
  ];

  #====<< Bootloader >>========================================================>
  # Be VERY careful when changing this, Nix is unbreakable in everything except
  # in one thing: messing with the boot-loader. You don't want to leave your
  # system in an unbootable state, so make sure you know what you are doing when
  # rebuilding any changes here. Best to first use a virtual machine with:
  # $ sudo nixos-rebuild build-wm-with-bootloader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 20;
    consoleMode = "0";
    memtest86.enable = true;
  };

  #====<< Misc options >>======================================================>
  nixnixpkgs.config.allowUnfree = false;
  console = {
    earlySetup = true;
    font = 
    let fontsize = "16";
    in "ter-i${fontsize}b";
    packages = [ pkgs.terminus_font ];
  };

  #====<< Linux kernel options >>==============================================>
  boot = {
    # By default the kernel is updated to the latest version deemed stable. Here
    # it is set to the latest release. Uncomment the line below to go use the
    # stable kernel. You can also select a specific version of the kernel like:
    # `pkgs.linuxKernel.kernels.linux_6_1`
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.systemd.enable = false;
  };

  #====<< Hardware Options >>==================================================>
  hardware = {
    # enableRedistributableFirmware = true;
    # enableAllFirmware = false;
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
