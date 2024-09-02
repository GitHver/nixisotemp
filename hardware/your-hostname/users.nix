{ alib, ... }:

let
  inherit (alib) makeUsers recursiveMerge umport;
in
{

  #====<< User management >>====================================================>
  users.mutableUsers = true; # Allows for imparative user management.
  users.users =
    let
      admins = makeUsers {
        userpaths = umport { path = ./users; };
        userrules = [ "wheel" "networkmanager" ];
      }; /*
      guests = makeUsers {
        userpaths  = umport { path = ./users; };
        userrules = [ "networkmanager" ]; }; */
    in admins # ++ guests
  ;
}
