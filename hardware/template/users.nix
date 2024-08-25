{ alib, ... }:

let
 inherit (alib) makeUsers recursiveMerge umport;
in {

 #====<< User management >>====================================================>
  users.mutableUsers = true;    # Allows for imparative user management.
  users.users = let
    t1 = makeUsers {
      userpaths  = umport { path = ./users; };
      userrules = [ "wheel" "networkmanager" ]; };
    # t2 = makeUsers {
    #   userpaths  = umport { path = ./users; };
    #   userrules = [ "networkmanager" ]; };
  in
    recursiveMerge [
      t1
      # t2 
    ];
}
