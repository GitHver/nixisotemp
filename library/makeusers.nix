{ lib, ... }:

let
  inherit (lib) nameValuePair;
  inherit (lib.lists) forEach;
  inherit (builtins) listToAttrs;

  makeUsers =
    { userpaths
    , userrules
    , normalUser ? true
    }:
    let
      users = forEach userpaths (user: import user);
    in
    listToAttrs (forEach users
      (user: nameValuePair user.un {
        isSystemUser = !normalUser;
        isNormalUser = normalUser;
        description = "${user.dn}";
        extraGroups = userrules;
        initialHashedPassword = 
          "$y$j9T$exX8G.UG6FWPaovI79bjC.$sJUZr3BYq6LUK0B0bN4VJ2mfpgZpFTFHVXsZAib6mxB";
        /* password is: Null&Nix1312 The reason that the password is in a
        hashed format is because this way you can have your git repository
        public without exposing the default password of new users. To make a
        hashed password, type: `mkpasswd -s` hit enter and then type your 
        password, then copy the hash and replace this hash with the new one. */
      })
    );

in
{ inherit makeUsers; }
