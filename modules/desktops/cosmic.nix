{ pkgs
, lib
, config
, inputs
, ...
}:

let
  inherit (lib) mkOption mkIf types;
  # name = services.desktopManager.cosmic.cachix;
  cfg = config.services.desktopManager.cosmic.cachix;
in {

  options.services.desktopManager.cosmic.cachix.enable = mkOption {
    type = types.bool;
    default = true;
  };

  config = mkIf cfg.enable { 
    nix.settings = {
      substituters = [ "https://cosmic.cachix.org/" ];
      trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
    };
  };
}
