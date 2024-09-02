{ patt, hostname, ... }:

let
  inherit (patt) system-path;
  home-path = "~/.config/home-manager";
in
{

  programs.bash.shellAliases = {
    home-get = ''
      git clone https://github.com/GitHver/nixisotemphome.git ${home-path}
      rm -rf ${home-path}/.git
      cd  ${home-path}
      $EDITOR flake.nix
    '';
    home-install = ''
      nix shell nixpkgs#home-manager --command home-manager switch --flake ${home-path}
      git init
      git add .
      git commit -m 'initial commit'
    '';
    # Incase you already have a home configuration
    home-init = ''
      nix shell nixpkgs#home-manager --command home-manager switch --flake ${home-path}
    '';
  };
}
