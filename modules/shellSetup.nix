{ pkgs
, ...
}:

let
  # inherit (patt) system-path;
  home-path = "~/.config/home-manager";
in {

  environment.shellAliases = {
    #====<< `/etc/nixos` setup >>================================================>
    nix-perms = /*sh*/''
      sudo chown -R $USER /etc/nixos
      chgrp -R wheel /etc/nixos
      chmod -R g+w /etc/nixos
      cd /etc/nixos
      git init
      git add .
      git commit -m 'initial commit'
    '';
    #====<< Home-manager install script >>=====================================>
    home-get = /*sh*/''
      git clone https://github.com/GitHver/nixisotemphome.git ${home-path}
      rm -rf ${home-path}/.git
      cd ${home-path}
      $EDITOR flake.nix
    '';
    home-install = /*sh*/''
      nix shell nixpkgs#home-manager --command home-manager switch --flake ${home-path}
      git init
      git add .
      git commit -m 'initial commit'
    '';
    # Incase you already have a home configuration
    home-init = /*sh*/''
      nix shell nixpkgs#home-manager --command home-manager switch --flake ${home-path}
    '';
    #====<< Other >>===========================================================>
    flathub-add = /*sh*/''
      flatpak remote-add --user flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
    swap-offset = /*sh*/''
      sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
    '';
  };

}
