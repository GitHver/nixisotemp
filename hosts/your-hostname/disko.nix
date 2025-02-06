{
  #====<< Main Disk >>=========================================================>
  # This is the main disk, arbitrarily named "mainDisk". This disk will contain
  # all the contents needed to boot into a working NixOS system. If you want
  # another disk to be itegrated into your system you can do so by adding
  # another entry like: `disko.devices.disk.someArbitraryName`. If you just need
  # to mount some disk as extra storage for images or games, then you do not
  # need to declare them here and you can simply mount them after booting.
  disko.devices.disk.main = {
    device = "/dev/disktype";
    type = "disk";
    content.type = "gpt";
    content.partitions = {

      #==<< Boot Partition >>==========>
      ESP = {
        type = "EF00";
        size = "512M";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };

      #==<< Main Partition >>==========>
      root = {
        size = "100%";
        # Uncomment the below to use LUKS encryption.
        # content = {
        #   type = "luks";
        #   name = "crypted";
        #   settings.allowDiscards = true;
        # }; content.
        content = {
          type = "filesystem";
          format = "xfs"; # Can also be "ext4" without needing any changes.
          mountpoint = "/";
          # mountOptions = [ "defaults" ];
        };
      };

    }; # Partitions
  }; # Main Drive

}
