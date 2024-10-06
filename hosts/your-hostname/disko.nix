let
  disktype =
    # "sda"
    # "nvme0n1"
    ;
in {
  disko.devices.disk = {

    main = {
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
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "noatime" "compress=zstd" ]; # "nodatacow"
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
                    swap.swapfile.size = "8G";
                  };
                }; # Subvolumes
              }; # Content
            # }; # LUKS content
          }; # Main partition

        }; # Partitions
      }; # Content
    }; # Main Drive

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
    #         }; # Bcache content
    #       }; # Bcache partition

    #     }; # Partitions
    #   }; # Content
    # }; # Secondary drive

  };
}
