{ lib, makeUsers, recursiveMerge, umport, ... }:

{
 #====<< User management >>====================================================>
  users.mutableUsers = true;    # Allows imparative user management.
  users.users = let
    t1 = makeUsers {
      userpaths  = umport { path = ./users; };
      userrules = [ "wheel" "networkmanager" ]; };
  in recursiveMerge [ t1 ];
}
