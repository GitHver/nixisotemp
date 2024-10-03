{ pkgs, ... }: {

  #=====<< Shell aliases >>====================================================>
  environment.shellAliases = let
    repository = "nixisotemp";
    default-directory = "hosts/your-hostname";
    mount-dir = "mnt/rootfs";
  in {
    yy = "sudo -E yazi";
    get-repo = ''
      sudo git clone https://github.com/GitHver/${repository}.git ./${repository}
      cd ${repository}
      sudo rm -rf .git
    '';
    mount-disko-n = ''
      sudo nix run github:nix-community/disko -- --mode disko ./${default-directory}/disko.nix
    '';
    mount-disko = ''
      sudo nix run github:nix-community/disko -- --mode disko ./${default-directory}/disko.nix
      sudo nixos-generate-config --no-filesystems --root /${mount-dir}
      sudo cp -r ~/${repository}/. /${mount-dir}/etc/nixos
      cd /${mount-dir}/etc/nixos
      sudo mv ./hardware-configuration.nix ./${default-directory}
      sudo rm ./configuration.nix
    '';
    install = "sudo nixos-install --flake .#your-hostname";
    instalt = ''
      sudo git clone https://github.com/GitHver/${repository}.git ./${repository}
      cd ${repository}
      sudo rm -rf .git

      sudo nix run github:nix-community/disko -- --mode disko ./${default-directory}/disko.nix
      sudo nixos-generate-config --no-filesystems --root /${mount-dir}
      sudo cp -r ~/${repository}/. /${mount-dir}/etc/nixos
      cd /${mount-dir}/etc/nixos
      sudo mv ./hardware-configuration.nix ./${default-directory}
      sudo rm ./configuration.nix

      sudo nixos-install --flake .#your-hostname
    '';
  };

}
