{ pkgs, lib, modulesPath, ... }:

{

 #====<< Imports >>============================================================>
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./../modules/localization.nix
  ];
  config = {
  
 #====<< Localization & internationalization >>================================>
  time.timeZone = "Atlantic/Reykjavik";
  i18n.defaultLocale  = "en_GB.UTF-8";  # Set default localization.
  extraLocaleSettings = "is_IS.UTF-8";  # Set main localization.
  console.keyMap = "is-latin1";         # Sets the console keymap.
  services.xserver.xkb = {              
    layout = "is";                # Set the keymap for Xserver.
    variant = "";                 # Your keyboard's variation, e.x  "104-key",
  };                              # It is not required.

 #====<< Installed packages >>=================================================>
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  environment.systemPackages = with pkgs; [
   #==<< Base utils >>=================>
    util-linux
    git
   #==<< Partition utils >>============>
    disko
    parted
   #==<< Terminal Navigation >>========>
    zellij
    helix
    yazi
    zoxide
    eza
    bat
   #==<< Internet >>===================>
    wget
    wpa_supplicant
   #==<< Other >>======================>
    marksman
    nil
    bash-language-server
  ];

 #====<< Nix specific settings >>==============================================>
  system.stateVersion = "24.11";          # What version of Nix to use
  nix.settings = {
    allowed-users = [ "root" "@wheel" ];  # Note: the wheel group is for admins.
    trusted-users = [ "root" "@wheel" ];
    experimental-features = [ "flakes" "nix-command" ];
  };

 #=====<< Shell aliases >>=====================================================>
  environment.shellAliases = {

    yy = "sudo -E yazi";

    get-inix = ''
      sudo git clone https://github.com/GitHver/inix.git ./inix
      cd inix
    '';
    edit-disko = ''
      hx ./hardware/template/disko.nix
    '';
    mount-disko = ''
      sudo nix run github:nix-community/disko -- --mode disko ./hardware/template/disko.nix
    '';
    genarate-config = ''
      sudo nixos-generate-config --no-filesystems --root /mnt
      sudo cp -r ~/inix/. /mnt/etc/nixos
      cd /mnt/etc/nixos
      sudo mv ./hardware-configuration.nix ./hardware/template
    '';
    install = ''
      git add .
      sudo nixos-install --flake .#template
    '';
    /*inix = ''
      sudo git clone https://github.com/GitHver/Personix.git ./inix
      cd inix
      sudo nix run github:nix-community/disko -- --mode disko ./hardware/template/disko.nix
      sudo nixos-generate-config --no-filesystems --root
      sudo mv /etc/nixos/hardware-configuration.nix ./hardware/template
      git add .
      sudo nixos-install --flake .#inix
    '';*/

};

  environment.variables = {
    EDITOR = "hx";  # this is so that yazi opens hx on 'o'.
  };

  programs.bash.loginShellInit = ''
    eval "$(zoxide init bash)"
    eval "$(starship init bash)"
    eval "$(zellij setup --generate-auto-start bash)"
  '';

};}
