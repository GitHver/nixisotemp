{
  disko.devices.disk = {
  
    main = {
      device = "/dev/nvme0n1";
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
            }; # boot contents
          }; # boot partition

          root = { # rename this to `luks` and uncomment all `luks` lines
            size = "100%";
            # content = {
            #   type = "luks";
            #   name = "crypted";
              content = {
                type = "btrfs";
                mountpoint = "/";
                extraArgs = [ "-L" "nixos" "-f" ];
                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "noatime" "compress=zstd" ];
                  };
                  "/rootfs" = {
                    mountpoint = "/";
                    mountOptions = [ "noatime" "compress=zstd" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "noatime" "compress=zstd" ];
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    mountOptions = [ "nodatacow" ];
                    swap.swapfile.size = "8G";
                  };
                  # "/persist" = {
                  #   mountpoint = "/persist";
                  #   mountOptions = [ "noatime" "compress=zstd" ];
                  # };
                }; # subvolumes
              }; # btrfs content
            # }; # luks content
          }; # root partition

        }; # partitions
      }; # content
    }; # main

    # secondary = {
    #   device = "/dev/sda";
    #   type = "disk";
    #   content = {
    #     type = "gpt";
    #     partitions = {

    #       cache = {
    #         size = "-8G";
    #         content = {
    #           type = "filesystem";
    #           format = "bcachefs";
    #           mountpoint = "/cache";
    #         }; # bcache content
    #       }; # bcachefs partition
          
    #     }; # partitions
    #   }; # content
    # }; # secondary drive
    
  };
}
