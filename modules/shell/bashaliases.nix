{ patt, hostname, ... }:

let
  inherit (patt) system-path;
  home-path = "~/.config/home-manager";
in {

  programs.bash.shellAliases = {
    
    rebuild = "sudo nixos-rebuild switch --flake ${system-path}#${hostname}";
    rollback = "sudo nixos-rebuild --rollback switch";
    update = "sudo nix flake update ${system-path}";
    upgrade = ''
      sudo nix flake update ${system-path}
      sudo nixos-rebuild switch --flake ${system-path}#${hostname}
    '';
    wipe = "sudo nix-collect-garbage -d";
    clean-D = "sudo nix-collect-garbage --delete-older-than 1d";
    clean-W = "sudo nix-collect-garbage --delete-older-than 7d";
    clean-M = "sudo nix-collect-garbage --delete-older-than 30d";

    home-get = ''
      git clone https://github.com/GitHver/nixisotemphome.git ${home-path}
      rm -rf ${home-path}/.git
      cd  ${home-path}
      $EDITOR flake.nix
    '';
    # Incase you already have a home configuration
    home-init = ''
      nix shell nixpkgs#home-manager --command home-manager switch --flake ${home-path}
    '';
    home-install = ''
      nix shell nixpkgs#home-manager --command home-manager switch --flake ${home-path}
      git init
      git add .
      git commit -m 'initial commit'
    '';

  };
}
