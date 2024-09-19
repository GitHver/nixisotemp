lib: {
  namesOfDirsIn = import ./namesOfDirsIn.nix { inherit lib; };
  attrsFromList = import ./attrsFromList.nix { inherit lib; };
  makeUsers     = import ./makeUsers.nix     { inherit lib; }; 
}
