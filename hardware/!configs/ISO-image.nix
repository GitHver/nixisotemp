{ pkgs, alib, modulesPath, ... }:

let
  username = "nixos";
  directory = "nixisotemp";
in {

 #====<< Imports >>============================================================>
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./../../modules/other/localization.nix
  ]; config = {

 #====<< Nixos user >>=========================================================>
  # home-manager.users."nixos" = { pkgs, ... }: {
  #   home.username = "${username}";
  #   home.homeDirectory = "/home/${username}";
  #   home.stateVersion = "24.05";
  #   programs.home-manager.enable = true;
    #home.file."inix" = {
    #  source = ./../.;
    #  recursive = true; };
  # };
  
 #====<< Network config >>=====================================================>
  networking = {
    hostName = "nixos";     # The name of your computer.
    networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
    wireless.enable = false;  # This is to prevent conflicts with networkmanager
  };

 #====<< Localization & internationalization >>================================>
  time.timeZone = "Atlantic/Reykjavik";
  i18n.defaultLocale  = "en_GB.UTF-8";  # Set default localization.
  extraLocaleSettings = "is_IS.UTF-8";  # Set main localization.
  console.keyMap = "is-latin1";         # Sets the console keymap.
  services.xserver.xkb = {              
    layout = "is";                # Set the keymap for Xserver.
    options = "caps:escape"; };

 #====<< Nix specific settings >>==============================================>
  system.stateVersion = "24.11";          # What version of Nix to use
  nix.settings = {
    allowed-users = [ "root" "@wheel" ];  # Note: the wheel group is for admins.
    trusted-users = [ "root" "@wheel" ];
    experimental-features = [ "flakes" "nix-command" ]; };

 #=====<< Shell aliases >>=====================================================>
  environment.shellAliases = {
    instructions = "bat /home/nixos/instructions.md";
    yy = "sudo -E yazi";
    wifi-connect = ''
      nmcli device wifi connect $wifiname password $wifipass
    '';
    get-repo = ''
      sudo git clone https://github.com/GitHver/${directory}.git ./${directory}
      cd ${directory}
    '';
    mount-disko = ''
      sudo nix run github:nix-community/disko -- --mode disko ./hardware/template/disko.nix
    '';
    generate-config = ''
      sudo nixos-generate-config --no-filesystems --root /mnt
      sudo cp -r ~/${directory}/. /mnt/etc/nixos
      cd /mnt/etc/nixos
      sudo mv ./hardware-configuration.nix ./hardware/template
      sudo rm ./configuration.nix
    '';
    install = ''
      sudo git add .
      sudo nixos-install --flake .#template
    '';
  };

  environment.variables = {
    EDITOR = "hx";  # this is so that yazi opens hx on 'o'.
  };

  programs.bash.loginShellInit = ''
    eval "$(zellij setup --generate-auto-start bash)"
    eval "$(zoxide init bash)"
  '';

 #====<< Installed packages >>=================================================>
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  environment.systemPackages = with pkgs; [
   #==<< Base utils >>=================>
    util-linux
    git
    gitui
   #==<< Partition utils >>============>
    disko
    parted
   #==<< Terminal Navigation >>========>
    zellij
    helix
    yazi
    zoxide
    fzf
    ripgrep
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

};}
