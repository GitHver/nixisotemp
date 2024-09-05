{
  disko.devices.disk = {
  
    main-disk = {
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
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              content = {
                type = "btrfs";
                mountpoint = "/";
                extraArgs = [ "L" "nixos" "-f" ];
                subvolumes = {
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "noatime" "nodatacow" ];
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
                    swap.swapfile.size = "20G";
                  };
                  # "/persist" = {
                  #   mountpoint = "/persist";
                  #   mountOptions = [ "noatime" "compress=zstd" ];
                  # };
                };
              };
            };
          };

        };
      };
    };

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
