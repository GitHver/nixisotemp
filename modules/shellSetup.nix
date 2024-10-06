{ ...
}:

let
  dir = "~/Nix";
  system-path = dir + "/nixos-system";
  home-path   = dir + "/home-manager";
in {

  environment.shellAliases = {
    #====<< /etc/nixos setup >>================================================>
    nix-move = /*sh*/ ''
      cd
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
    home-host = /*sh*/ ''
      $EDITOR ~/Nix/home-manager/hosts/your-host.nix
    '';
    home-install = /*sh*/ ''
      nix shell nixpkgs#home-manager --command home-manager switch
    '';
    #====<< Git repo initialization >>=========================================>
    nix-git = /*sh*/ ''
      cd ${system-path}
      git init
      git add .
      git commit -m 'initial commit'
      cd ${home-path}
      git init
      git add .
      git commit -m 'initial commit'
      cd
    '';
    #====<< Other >>===========================================================>
    swap_offset = /*sh*/ ''
      sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    '';
    flathub-add = /*sh*/ ''
      flatpak remote-add --user flathub "
      https://dl.flathub.org/repo/flathub.flatpakrepo"
    '';
  };

}
