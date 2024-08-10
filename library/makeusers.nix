{ lib, ... }:

let
  inherit (lib) nameValuePair;
  inherit (lib.lists) forEach;
  inherit (builtins) listToAttrs;

  makeUsers = { userpaths, userrules }: let
    users = forEach userpaths (user: import user);
  in
    listToAttrs (forEach users
      (user: nameValuePair user.un {
        isNormalUser = true;
        description = "${user.dn}";
        initialPassword = "${user.pw}";
        extraGroups = userrules;
      })
    );

in { inherit makeUsers; }
