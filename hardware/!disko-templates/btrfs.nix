{
  disko.devices.disk.main = {

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

        root = {
          size = "100%";
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
}
