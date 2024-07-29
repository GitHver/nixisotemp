{ pkgs, ... }:

{

 #====<< System packages >>====================================================>
  nixpkgs.config.allowUnfree = true; 
  environment.systemPackages = with pkgs; [
   #==<< pkgs >>=======================>
    zip           # Compression tool 
    unzip         # Unzipping until
   #==<< C utils >>====================>
    gcc           # GNU C Compiler
    clang         # clang compiler
    gnumake       # GNU c make
   #==<< Navigation >>=================>
    ripgrep       # Rust regex search
    fzf           # terminal fuzzy finder
   #==<< Ohter >>======================>
    wget          # Web get
    cachix
    wl-clipboard  # Wayland clipboard tool
    neofetch      # 
   #==<< Bevy >>=======================>
    pkg-config
    alsa-lib
    libudev-zero
  ];

}
