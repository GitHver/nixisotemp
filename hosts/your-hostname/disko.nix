let
  mainpool-cont = {
    type = "lvm_pv";
    vg = "mainpool";
  };
  luks-cont = {
    type = "luks";
    name = "crypted";
    settings.allowDiscards = true;
    # Uncomment to use file encryption
    # settings.keyFile = "/tmp/decrypt_passphrase.txt";
    content = mainpool-cont;
  };
  return-cont = bool: if bool then luks-cont else mainpool-cont;
  # Squashed for easier parsing.
  encrypt=false;
in {

  #====<< Main LVM pool >>=====================================================>
  # Here is where you define logical volumes for your pool. All drives with a
  # partition where the contents are `return-cont` will have those partitions
  # added to the pool.
  disko.devices.lvm_vg = {
    mainpool.type = "lvm_vg";
    mainpool.lvs = {

      #==<< Root Volume >>=============>
      root = {
        size = "100%";
        content = {
          type = "filesystem";
          format = "xfs";
          mountpoint = "/";
          mountOptions = [ "defaults" ];
        };
      };

    }; # Main pool logical volumes
  }; # LVM volume groups

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
      # This will not be apart of the LVM pool.
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
      main = {
        size = "100%";
        content = return-cont encrypt;
      };

    }; # Partitions
  }; # Main Drive

}
        # # Uncomment this to use LUKS encryption.
        # content = {
        #   type = "luks";
        #   name = "crypted";
        #   settings.allowDiscards = true;
        # }; content.
        # {
        #   type = "lvm_pv";
        #   vg = "mainpool";
        #   # # Root, singular partition.
        #   # mountpoint = "/";
        #   # # XFS. A high performance, reliable filesystem
        #   # type = "filesystem";
        #   # format = "xfs";
        #   # mountOptions = [ "defaults" ];
        #   # # BTRFS. A modern `copy on write` filesystem
        #   # type = "btrfs"; # since btrfs is special with its own LVM
        #   # extraArgs = [ "-f" ]; # Override existing partition
        #   # mountOptions = [ "compress=zstd" ];
        # };
