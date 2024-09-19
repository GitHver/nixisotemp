{ lib }:

let
  inherit (lib.lists) foldl;
  attrsFromList = (list: foldl (a: b: a // b) { } list);
in attrsFromList
