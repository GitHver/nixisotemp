{ ... }:

let
  dir = "~/Nix";
  system-path = dir + "/nixos-system";
  home-path   = dir + "/home-manager";
in {

  environment.shellAliases = {
    #====<< /etc/nixos setup >>================================================>
    nix-move = /*sh*/ ''
      # Create the `Nix` directory and copy the contents of `/etc/nixos` into it
      mkdir ~/Nix
      cp -R /etc/nixos ${system-path}
      # Remove the existing files and replace them with a symlink to the flake
      sudo rm -rf /etc/nixos/*
      sudo ln -s ${system-path}/flake.nix /etc/nixos/flake.nix
    '';
    #====<< Home-manager install script >>=====================================>
    home-get = /*sh*/ ''
      # Clone the repository and remove the git repo
      git clone https://github.com/GitHver/nixisotemphome.git ${home-path}
      rm -rf ${home-path}/.git
      # Creates a symbolic link in the home-manager directory
      mkdir ~/.config/home-manager
      ln -s ${home-path}/flake.nix ~/.config/home-manager
      # Open the flake in the editor
      $EDITOR ${home-path}/flake.nix
      $EDITOR ~/Nix/home-manager/hosts/your-host.nix
    '';
    home-install = /*sh*/ ''
      # Install and run home-manager
      nix shell nixpkgs#home-manager --command home-manager switch
    '';
    #====<< Git repo initialization >>=========================================>
    nix-git = /*sh*/ ''
      # Initialize the system git repository
      cd ${system-path}
      git init
      git add .
      git commit -m 'initial commit'
      # Initialize the Home-manager git repository
      cd ${home-path}
      git init
      git add .
      git commit -m 'initial commit'
      # Go back home
      cd
    '';
    #====<< Full setup >>======================================================>
    nix-setup = /*sh*/ ''
      # Create the `Nix` directory and copy the contents of `/etc/nixos` into it
      mkdir ${dir}
      cp -R /etc/nixos ${system-path}
      # Remove the existing files and replace them with a symlink to the flake
      sudo rm -rf /etc/nixos/*
      sudo ln -s ${system-path}/flake.nix /etc/nixos/flake.nix
      # Clone the repository and remove the git repo
      git clone https://github.com/GitHver/nixisotemphome.git ${home-path}
      rm -rf ${home-path}/.git
      # Creates a symbolic link in the home-manager directory
      mkdir ~/.config/home-manager
      ln -s ${home-path}/flake.nix ~/.config/home-manager
      # Open the flake in the editor to change variables to their correct values
      $EDITOR ${home-path}/flake.nix
      $EDITOR ~/Nix/home-manager/hosts/your-host.nix
      # Install and run home-manager
      nix shell nixpkgs#home-manager --command home-manager switch
      # Initialize the system git repository
      cd ${system-path}
      git init
      git add .
      git commit -m 'initial commit'
      # Initialize the Home-manager git repository
      cd ${home-path}
      git init
      git add .
      git commit -m 'initial commit'
      # Go back home
      cd
    '';
    #====<< Other >>===========================================================>
    swap-offset = /*sh*/ ''
      sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    '';
    flathub-add = /*sh*/ ''
      flatpak remote-add --user flathub "
      https://dl.flathub.org/repo/flathub.flatpakrepo"
    '';
  };

}
