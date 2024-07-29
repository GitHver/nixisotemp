{ system-path, hostname, ... }:

{
  programs.bash.shellAliases = {
    
    rebuild = "sudo nixos-rebuild switch --flake ${system-path}#${hostname}";
    update = "sudo nix flake update ${system-path}";

    clean-D = "sudo nix-collect-garbage --delete-older-than 1d";
    clean-W  = "sudo nix-collect-garbage --delete-older-than 1w";
    clean-M  = "sudo nix-collect-garbage --delete-older-than 1m";

    upgrade-s = ''
      sudo nix flake update ${system-path}
      sudo nixos-rebuild switch --flake ${system-path}#${hostname}
    '';
    wipe = ''
      sudo nix-collect-garbage -d
    '';
    home-install = ''
      nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
      nix-channel --update
      unset __HM_SESS_VARS_SOURCED ; . ~/.profile
      nix-shell '<home-manager>' -A install
    '';
  };
}
