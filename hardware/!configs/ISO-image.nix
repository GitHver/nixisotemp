{ pkgs, alib, modulesPath, ... }:

let
in {

  #====<< Imports >>===========================================================>
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
    ./../../modules/other/localization.nix
  ];
  config = {

    #====<< xserver >>===========================================================>
    # services.xserver.enable = true;
    # services.xserver.exportConfiguration = true;

    #====<< Network config >>====================================================>
    networking = {
      hostName = "nixos"; # The name of your computer.
      networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
      wireless.enable = false; # This is to prevent conflicts with networkmanager
    };

    #====<< Localization & internationalization >>===============================>
    time.timeZone = "Atlantic/Reykjavik";
    i18n.defaultLocale = "en_GB.UTF-8"; # Set default localization.
    extraLocaleSettings = "is_IS.UTF-8"; # Set main localization.
    console.keyMap = "is-latin1"; # Sets the console keymap.
    services.xserver.xkb = {
      layout = "is"; # Set the keymap for Xserver.
      options = "caps:escape";
    };

    #====<< Nix specific settings >>=============================================>
    system.stateVersion = "24.11"; # What version of Nix to use
    nix.settings = {
      allowed-users = [ "root" "@wheel" ]; # Note: the wheel group is for admins.
      trusted-users = [ "root" "@wheel" ];
      experimental-features = [ "flakes" "nix-command" ];
    };

    #=====<< Shell aliases >>====================================================>
    environment.shellAliases =
      let
        repository = "nixisotemp";
        default-directory = "hardware/your-hostname";
      in
      {
        yy = "sudo -E yazi";
        get-repo = ''
          sudo git clone https://github.com/GitHver/${repository}.git ./${repository}
          cd ${repository}
          sudo rm -rf .git
        '';
        mount-disko = ''
          sudo nix run github:nix-community/disko -- --mode disko ./${default-directory}/disko.nix
          sudo nixos-generate-config --no-filesystems --root /mnt
          sudo cp -r ~/${repository}/. /mnt/etc/nixos
          cd /mnt/etc/nixos
          sudo mv ./hardware-configuration.nix ./${default-directory}
          sudo rm ./configuration.nix
        '';
        install = "sudo nixos-install --flake .#your-hostname";
        instant = ''
          sudo git clone https://github.com/GitHver/${repository}.git ./${repository}
          cd ${repository}
          sudo rm -rf .git

          sudo nix run github:nix-community/disko -- --mode disko ./${default-directory}/disko.nix
          sudo nixos-generate-config --no-filesystems --root /mnt
          sudo cp -r ~/${repository}/. /mnt/etc/nixos
          cd /mnt/etc/nixos
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
      util-linux
      git
      gitui
      #==<< Partition utils >>===========>
      disko
      parted
      #==<< Terminal Navigation >>=======>
      zellij
      helix
      yazi
      zoxide
      fzf
      ripgrep
      eza
      bat
      #==<< Internet >>==================>
      wget
      wpa_supplicant
      #==<< Other >>=====================>
      marksman
      nil
      bash-language-server
    ];

  };
}
