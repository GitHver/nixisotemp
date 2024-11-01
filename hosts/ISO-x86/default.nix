# Using the following command, a result directory will be made
# with a custom ISO in the 'result/iso' directory.
# $ nix build \.#nixosConfigurations.ISO.config.system.build.isoImage
# put your packages you want on the ISO in the `hosts/ISO-image.nix` file

{ pkgs, lib, modulesPath, ... }:

{
  #====<< Imports >>===========================================================>
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ./install-script.nix
  ];

  config = {

  #====<< System Services >>===================================================>
  services = {
    # The COSMIC desktop environment. Wayland based & Rust made.
    # displayManager.cosmic-greeter.enable = true;
    # desktopManager.cosmic.enable = true;
  };

  #====<< Network config >>====================================================>
  networking = {
    hostName = "nixos"; # The name of your computer.
    networkmanager.enable = true; # Networkmanager handles wifi and ethernet.
    wireless.enable = false; # This is to prevent conflicts with networkmanager
  };

  #====<< Localization & internationalization >>===============================>
  localization = {
    # i18n locale. You can find available locales with `locale -a`.
    language   = "en_AU" + ".UTF-8";
    formatting = "is_IS" + ".UTF-8";
    # Your time zone. See all available with `timedatectl list-timezones`.
    timezone   = "Atlantic/Reykjavik";
  };

  #====<< Keyboard >>==========================================================>
  console.useXkbConfig = true;  # Makes the virtual terminal use the xkb config.
  services.xserver.xkb = {
    layout  = "is";           # Set the language keymap for XKeyboard.
    variant = "";             # Any special layout you use like colemak, dvorak.
    model   = "pc104";        # The keyboard model. default is 104 key.
    options = "caps:escape";  # Here, Capslock is an additional escape key. 
  };
  services.xremap.config.keymap = [
    { name = "orvar";
    remap = {
      "M-h" = "LEFT";
      "M-J" = "DOWN";
      "M-K" = "UP";
      "M-L" = "RIGHT";
      "M-SHIFT-h" = "HOME";
      "M-SHIFT-J" = "PAGEDOWN";
      "M-SHIFT-K" = "PAGEUP";
      "M-SHIFT-L" = "END";
    };}
  ];

  #====<< Nix specific settings >>=============================================>
  system.stateVersion = "24.11";  # What version of NixOS configs to use.
  # Here you can specify the version of Nix you want to use. The current
  # stable is `2.18.x`. You can also use Lix instead.
  nix.package = pkgs.nixVersions.latest;
  nix.settings = {
    # Access rights to the Nix deamon. This is a list of users, but you can
    # specify groups by prefixing an entry with `@`. `*` is everyone.
    allowed-users = [ "*" ];
    trusted-users = [ "root" "@wheel" ];
    # These are features needed for flakes to work. You can find more at:
    # https://nix.dev/manual/nix/2.24/development/experimental-features
    experimental-features = [ "flakes" "nix-command" ];
    # Replaces identical files with links to save space. works the same as:
    # `nix store optimise`
    auto-optimise-store = true;
  };

  #====<< Miscellaneous >>=====================================================>
  # xdg.portal.enable = true; # XDG Desktop portal (for nix and flatpaks).
  documentation.nixos.enable = false; # Removes the NixOS manual application.
  services.printing.enable = false;   # Printer protocols. Enable for support.
  # Nix ld is one solution to the static binary problem. This only affects you
  # if you need to run random binaries from sources other than nixpkgs. Learn
  # more here: https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = (with pkgs; [ ]);

  environment.variables = {
    EDITOR = "hx"; # this is so that yazi opens hx on 'o'/'enter'.
  };

  #====<< Installed packages >>================================================>
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  environment.systemPackages = with pkgs; [
    #==<< Base utils >>================>
    git
    gitui
    #==<< Partition utils >>===========>
    disko
    parted
    #==<< Terminal Navigation >>=======>
    zellij
    helix
    yazi
    btop
    nil
    bash-language-server
    #==<< COSMIC apps >>===============>
    alsa-utils
    cosmic-applets
    cosmic-applibrary
    cosmic-bg
    (cosmic-comp.override {
      useXWayland = true;
    })
    cosmic-edit
    cosmic-files
    cosmic-greeter
    cosmic-icons
    cosmic-launcher
    cosmic-notifications
    cosmic-osd
    cosmic-panel
    cosmic-randr
    cosmic-screenshot
    cosmic-session
    cosmic-settings
    cosmic-settings-daemon
    cosmic-term
    cosmic-wallpapers
    cosmic-workspaces-epoch
    hicolor-icon-theme
    playerctl
    pop-icon-theme
    pop-launcher
    cosmic-greeter
  ];

};}
