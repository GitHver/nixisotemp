{ lib, makeUsers, recursiveMerge, ... }:

{
 #====<< User management >>====================================================>
  users.mutableUsers = true;         # Makes the home directory writeable.
  users.users = let
    t1 = makeUsers {
      userpath  = ./users;
      userrules = [ "wheel" "networkmanager" ]; };
  in recursiveMerge [ t1 ];
}
