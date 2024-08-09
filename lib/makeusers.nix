{ lib, ... }:

let
  inherit (lib) nameValuePair;
  inherit (lib.lists) forEach;
  inherit (builtins) listToAttrs;

  makeUsers = { userlist, userrules }: let
    users = forEach userlist (user: import ./../users/${user}.nix);
  in 
    listToAttrs (forEach users
      (user: nameValuePair user.un {
        isNormalUser = true;
        description = "${user.dn}";
        initialHashedPassword = "${user.pw}";
        extraGroups = userrules;
      })
    );

in { inherit makeUsers; }
