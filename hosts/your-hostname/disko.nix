# Swap options are at the bottom of the file.
{
  #====<< Main Disk >>=========================================================>
  # This is the main disk, arbitrarily named "mainDisk". This disk will contain
  # all the contents needed to boot into a working NixOS system. If you want
  # another disk to be itegrated into your system you can do so by adding
  # another entry like: `disko.devices.disk.someArbitraryName`. If you just need
  # to mount some disk as extra storage for images or games, then you do not
  # need to declare them here and you can simply mount them after booting.
  disko.devices.disk.mainDisk = let
    disktype = # The type of disk your system has.
      # "sda"
      # "nvme0n1"
    ;
  in {
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
                  mountOptions = [ /*"compress=zstd"*/ ]; # compression may complicate data recovery
                };
              }; # Subvolumes
            }; # Content
          # }; # LUKS content
        }; # Main partition
      }; # Partitions
    }; # Content
  }; # Main Drive

  #====<< Swap options >>======================================================>
  # ZRAM creates a block device in you RAM that works as swap. It compresses all
  # the contents moved there, effectively increasing your RAM size at the cost
  # of some processing power. https://nixos.wiki/wiki/Swap#Enable_zram_swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    algorithm = "zstd";
  };
  # This is needed for traditional swap. You can set this up after installation
  # if ZRAM is not enough for you. You'll need to run:
  # `sudo btrfs subvolume create /swap`
  # `sudo chattr +C /swap`
  # `cd /swap`
  # `sudo btrfs filesystem mkswapfile --size [sizeyouwant(e.g "8G")] swapfile`
  # `sudo swapon swapfile`
  # Then uncomment the below and rebuild switch.
  # swapDevices = [ { device = "/swap/swapfile"; } ];
  # fileSystems."/swap" = {
  #   device = "/dev/disk/by-label/nixos";
  #   fsType = "btrfs";
  #   options = [ "subvol=swap" "noatime" ];
  # };
  # This is needed for hibernation. After setting up swap, Run `swap-offset` and
  # put the number here and uncomment the below for hibernation to work.
  # boot.kernelParams =
  # let resume-offset = "533760";
  # in [ "resume_offset=${resume-offset}" ];
  # boot.resumeDevice = "/dev/disk/by-label/nixos";

}
