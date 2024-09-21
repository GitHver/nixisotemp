let
  disktype =
    # "nvme0n1"
    # "sda"
    # "vda"
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

          root = { # rename to `luks` if using encryption
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
                }; # subvolumes
              }; # btrfs content
            # }; # luks content
          }; # root partition

        }; # partitions
      }; # disk content
    }; # main disk

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
    #         };
    #       };

    #     }; # partitions
    #   }; # content
    # };

  };
}
