{ pa, ... }:
let
  inherit (pa) system-path hostname;
in
{
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

    sga = "sudo git add .";
    sgc = "sudo -E git commit";

    home-install = ''
      nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
      nix-channel --update
      nix-shell '<home-manager>' -A install
    '';

    ssh-setup1 = ''
      echo 'ssh-keygen -t ed25519 -C "your@email.host"'
    '';
    ssh-setup2 =''
      echo '
      Host *
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519'
    '';
    shh-setup3 = ''
      touch ~/.ssh/config
      $EDITOR ~/.ssh/config
    '';
    shh-setup4 = ''
      ssh-add ~/.ssh/id_ed25519
      cat ~/.ssh/id_ed25519.pub
    '';

  };
}
