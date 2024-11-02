let
  # The type of disk your system has.
  disktype =
    # "sda"
    # "nvme0n1"
  ;
  # The size of the swap file. Uncomment the `/swap` subvolume to enable swap.
  # If you want hibernation then this needs to be larger than the size of your
  # RAM. Beware; changing the size after installation is not intuitive.
  swapsize = "8G";
  # This is needed for hibernation. After boot, Run `swap-offset` and put the
  # number here. The option that uses this variable is at the bottom of the file
  # and needs to be uncommented for hibernation to work.
  resume-offset = "533760";
in {

  #====<< Main Disk >>=========================================================>
  # This is the main disk, arbitrarily named "mainDisk". This disk will contain
  # all the contents needed to boot into a working NixOS system. If you want
  # another disk to be itegrated into your system you can do so by adding
  # another entry like: `disko.devices.disk.someArbitraryName`. If you just need
  # to mount some disk as extra storage for images or games, then you do not
  # need to declare them here and you can simply mount them after booting.
  disko.devices.disk.mainDisk = {
    device = "/dev/${disktype}";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          type = "EF00";
          size = "512M";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          # content = {
          #   type = "luks";
          #   name = "crypted";
            content = {
              type = "btrfs";
              mountpoint = "/";
              extraArgs = [ "-L" "nixos" "-f" ];
              subvolumes = {
                "/nix" = { # The nix store and variables.
                  mountpoint = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" /*"nodatacow"*/ ];
                };
                "/rootsv" = { # "root subvolume", Everything else.
                  mountpoint = "/";
                  mountOptions = [ "compress=zstd" ];
                };
                "/home" = { # The home directory for the users.
                  mountpoint = "/home";
                  mountOptions = [ "compress=zstd" ];
                };
                # "/swap" = { # Swap. For extra RAM or hibernation.
                #   mountpoint = "/.swap";
                #   swap.swapfile.size = swapsize;
                # };
              }; # Subvolumes
            }; # Content
          # }; # LUKS content
        }; # Main partition
      }; # Partitions
    }; # Content
  }; # Main Drive

  #====<< Other options >>=====================================================>
  # ZRAM creates a block device in you RAM that works as swap. It compresses all
  # the contents moved there, effectively increasing your RAM size at the cost
  # of some processing power. https://nixos.wiki/wiki/Swap#Enable_zram_swap
  zramSwap.enable = true;
  # uncomment the below if you want to use hibernation.
  # boot.kernelParams = [ "resume_offset=${resume-offset}" ];
  # boot.resumeDevice = "/dev/disk/by-label/nixos";

}
