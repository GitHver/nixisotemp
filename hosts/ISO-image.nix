{ pkgs, lib, modulesPath, ... }:

{
  #====<< Imports >>===========================================================>
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./../modules/localization.nix
  ];
  config = {

  services = {
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };

  #====<< Network config >>====================================================>
  networking = {
    hostName = "nixos"; # The name of your computer.
    networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
    wireless.enable = false; # This is to prevent conflicts with networkmanager
  };

  #====<< Localization & internationalization >>===============================>
  localization = {
    language   = "en_GB";
    formatting = "is_IS";
    timezone   = "Atlantic/Reykjavik";
  };

  #====<< Keyboard >>==========================================================>
  console.useXkbConfig = true;
  services.xserver.xkb = {
    layout  = "is";           # Set the language keymap for XKeyboard.
    variant = "";             # Any special layout you use like colemak, dvorak.
    model   = "pc104";        # The keyboard model. default is 104 key.
    options = "caps:escape";  # Here, Capslock is an additional escape. 
  };

  #====<< Nix specific settings >>=============================================>
  system.stateVersion = "24.11"; # What version of Nix to use
  nix.channel.enable = false;
  nix.settings = {
    allowed-users = [ "*" ]; # Note: the wheel group is for admins.
    trusted-users = [ "root" "@wheel" ];
    experimental-features = [ "flakes" "nix-command" ];
  };

  #=====<< Shell aliases >>====================================================>
  environment.shellAliases = let
    repository = "nixisotemp";
    default-directory = "hosts/your-hostname";
    mount-dir = "mnt/rootfs";
  in {
    yy = "sudo -E yazi";
    get-repo = ''
      sudo git clone https://github.com/GitHver/${repository}.git ./${repository}
      cd ${repository}
      sudo rm -rf .git
    '';
    mount-disko-n = ''
      sudo nix run github:nix-community/disko -- --mode disko ./${default-directory}/disko.nix
    '';
    mount-disko = ''
      sudo nix run github:nix-community/disko -- --mode disko ./${default-directory}/disko.nix
      sudo nixos-generate-config --no-filesystems --root /${mount-dir}
      sudo cp -r ~/${repository}/. /${mount-dir}/etc/nixos
      cd /${mount-dir}/etc/nixos
      sudo mv ./hardware-configuration.nix ./${default-directory}
      sudo rm ./configuration.nix
    '';
    install = "sudo nixos-install --flake .#your-hostname";
    instalt = ''
      sudo git clone https://github.com/GitHver/${repository}.git ./${repository}
      cd ${repository}
      sudo rm -rf .git

      sudo nix run github:nix-community/disko -- --mode disko ./${default-directory}/disko.nix
      sudo nixos-generate-config --no-filesystems --root /${mount-dir}
      sudo cp -r ~/${repository}/. /${mount-dir}/etc/nixos
      cd /${mount-dir}/etc/nixos
      sudo mv ./hardware-configuration.nix ./${default-directory}
      sudo rm ./configuration.nix

      sudo nixos-install --flake .#your-hostname
    '';
  };

  environment.variables = {
    EDITOR = "hx"; # this is so that yazi opens hx on 'o'/'enter'.
  };

  #====<< Installed packages >>================================================>
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  environment.systemPackages = with pkgs; [
    #==<< Base utils >>================>
    # util-linux
    git
    # gitui
    #==<< Partition utils >>===========>
    disko
    # parted
    #==<< Terminal Navigation >>=======>
    zellij
    helix
    yazi
    # zoxide
    # fzf
    # ripgrep
    # eza
    # bat
    #==<< Internet >>==================>
    # wget
    # wpa_supplicant
    #==<< Other >>=====================>
    # marksman
    nil
    # bash-language-server
  ];

};}
