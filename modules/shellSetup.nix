{ pkgs
, host
, ...
}:

let
  dir = "~/Nix";
  system-path = dir + "/nixos-system";
  home-path   = dir + "/home-manager";
in {

  environment.shellAliases = {
    #====<< Full setup >>======================================================>
    home-setup = /*sh*/ ''
      # Create the `Nix` directory
      mkdir ${dir}
      mkdir ${home-path}
      # Clone the repository and remove the git repo
      nix shell nixpkgs#git --command git clone https://github.com/GitHver/nixisotemphome.git ${home-path}
      rm -rf ${home-path}/.git
      # Creates a symbolic link in the home-manager directory
      mkdir ~/.config/home-manager
      ln -s ${home-path}/flake.nix ~/.config/home-manager
      # Open the flake in the editor to change variables to their correct values
      $EDITOR ${home-path}/flake.nix
      # Create the `hosts` drectory in the home manager repo
      cd ${home-path}
      mkdir hosts
      cd
      # Create a file with the host name of the current machine
      echo '{
        name = "${host}";
        system = # Choose the right architecture for this machine
          "x86_64-linux"
          # "aarch64-linux"
        ;
      }' > ${home-path}/hosts/${host}.nix
      $EDITOR ${home-path}/hosts/${host}.nix
      # Install and run home-manager
      nix shell nixpkgs#home-manager --command home-manager switch
      # Initialize the Home-manager git repository
      cd ${home-path}
      git init
      git add .
      git commit -m 'initial commit'
      # Go back home
      cd
    '';
    nix-move = /*sh*/ ''
      cp -R /etc/nixos ${system-path}
      # Remove the existing files and replace them with a symlink to the flake
      sudo rm -rf /etc/nixos/*
      sudo ln -s ${system-path}/flake.nix /etc/nixos/flake.nix
      # Initialize the system git repository
      cd ${system-path}
      git init
      git add .
      git commit -m 'initial commit'
      cd
    '';
    #====<< Pre-existing setup >>==============================================>
    ssh-perms = /*sh*/ ''
      chmod 644 ~/.ssh/config
      chmod 644 ~/.ssh/known_hosts.old
      chmod 644 ~/.ssh/id_ed25519.pub
      chmod 600 ~/.ssh/known_hosts
      chmod 600 ~/.ssh/id_ed25519
      ssh-agent -s
      ssh-add ~/.ssh/id_ed25519
    '';
    pre-ex-setup = /*sh*/ ''
      mkdir ~/Nix
      cd ~/Nix
      echo '
        use `nix shell nixpkgs#git` to bootstrap git to the system and 
        then `git clone` your repositories into their correct directories.
        `git clone git@webhost.domain:Username/repository.git `home-manager`
        or
        `git clone git@webhost.domain:Username/repository.git `nixos-system`

        then use `symbolic-link` to symlink the flakes to their expected locations.
      '
    '';
    symbolic-link = /**/ ''
      mkdir ~/.config/home-manager
      ln -s ${home-path}/flake.nix ~/.config/home-manager/flake.nix
      sudo rm -rf /etc/nixos/*
      sudo ln -s ${system-path}/flake.nix /etc/nixos/flake.nix
    '';
    #====<< Other >>===========================================================>
    swap-offset = /*sh*/ ''
      sudo btrfs inspect-internal map-swapfile -r /.swap/swapfile
    '';
    flathub-add = /*sh*/ ''
      flatpak remote-add --user flathub "https://dl.flathub.org/repo/flathub.flatpakrepo"
    '';
    ssh-keygen-setup = /*sh*/ ''
      echo '
      copy the following and replace it with your email and then run it
        ssh-keygen -t ed25519 -C "your@email.domain"
      after that run:
        ssh-setup
      '
    '';
    ssh-setup = /*sh*/ ''
      echo '
      Host *
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519
      ' > ~/.ssh/config

      eval $(ssh-agent -s)
      ssh-add ~/.ssh/id_ed25519
      echo "This is your public key:"
      cat ~/.ssh/id_ed25519.pub
    '';
  };

}
