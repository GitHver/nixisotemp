{ patt, hostname, ... }:

let
  inherit (patt) system-path;
in {

  programs.bash.shellAliases = {
    
    rebuild = "sudo nixos-rebuild switch --flake ${system-path}#${hostname}";
    update = "sudo nix flake update ${system-path}";
    upgrade = ''
      sudo nix flake update ${system-path}
      sudo nixos-rebuild switch --flake ${system-path}#${hostname}
    '';
    wipe = "sudo nix-collect-garbage -d";
    clean-D = "sudo nix-collect-garbage --delete-older-than 1d";
    clean-W = "sudo nix-collect-garbage --delete-older-than 1w";
    clean-M = "sudo nix-collect-garbage --delete-older-than 1m";

    sga = "sudo -E git add .";
    sgc = "sudo -E git commit";

    home-install = ''
      nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
      nix-channel --update
      nix-shell '<home-manager>' -A install
    '';
    # or
    # nix run home-manager/$branch -- init --switch ~/hmconf
    # or
    # nix shell nixpkgs#home-manager
    # nix shell nixpkgs#home-manager --command home-manager switch --flake ~/Nix/home

    ssh1 = ''
      echo '
      copy the following and replace it with your email and then run it

      ssh-keygen -t ed25519 -C "your@email.host"'
    '';
    ssh2 =''
      echo '
      copy the below and pasrte it into the next step
      
      Host *
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519'
    '';
    ssh3 = ''
      touch ~/.ssh/config
      $EDITOR ~/.ssh/config
    '';
    ssh4 = ''
      ssh-add ~/.ssh/id_ed25519
      cat ~/.ssh/id_ed25519.pub
    '';

  };
}
