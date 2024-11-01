let
  disktype =
    # "sda"
    # "nvme0n1"
  ;
in {
  # ZRAM creates a block device in you RAM that works as swap. It compresses all
  # the contents moved there, effectively increasing your RAM size at the cost
  # of some processing power. https://nixos.wiki/wiki/Swap#Enable_zram_swap
  zramSwap.enable = false;
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
                "/swap" = { # Swap. For extra RAM or hibernation.
                  mountpoint = "/.swap";
                };
              }; # Subvolumes
            }; # Content
          # }; # LUKS content
        }; # Main partition
      }; # Partitions
    }; # Content
  }; # Main Drive
}
