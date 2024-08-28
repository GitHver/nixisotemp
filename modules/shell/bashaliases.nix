{ patt, hostname, ... }:

let
  inherit (patt) system-path;
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
      git clone https://github.com/GitHver/nixisotemphome.git ~/Home
      cd  ~/Home
      rm -rf ~/Home/.git
      $EDITOR flake.nix
    '';
    home-install = ''
      nix shell nixpkgs#home-manager --command home-manager switch --flake ~/Home
      cd ~/Home
      git init
      git add .
      git commit -m 'initial commit'
      home-manager switch --flake ~/Home
    '';

    git-system = ''
      cd /etc/nixos
      sudo -E git init
      sudo -E git add .
      sudo -E git commit -m 'inital commit'
      cd
    '';

    sga = "sudo -E git add .";
    sgc = "sudo -E git commit";
    sgp = "sudo -E git push";

  };
}
