{ lib, ... }:

let
  inherit (lib) makeUsers recursiveMerge;
  inherit (lib.filesystem) listFilesRecursive;
in {
  #====<< User management >>====================================================>
  users.mutableUsers = true; # Allows for imparative user management.
  users.users = let
    admins = makeUsers {
      userpaths = listFilesRecursive ./users; 
      userrules = [ "wheel" "networkmanager" ]; };
    # guests = makeUsers {
    #   userpaths = listFilesRecursive ./guests;
    #   userrules = [ "networkmanager" ]; };
  in admins
  # // guests
  ;
}
