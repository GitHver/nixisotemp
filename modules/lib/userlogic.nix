{ lib, umport, adminusers, ... }:

{
# ==== User management ======================================================= #
  users.users = with lib; let

  
    recursiveMerge = attrList:
      let f = attrPath:
        zipAttrsWith (n: values:
          if tail values == []
            then head values
          else if all isList values
            then unique (concatLists values)
          else if all isAttrs values
            then f (attrPath ++ [n]) values
          else last values );
      in f [] attrList;

    inherit (lib.lists) forEach;
    

    guest = { un = "guest"; dn = "Guests"; };
    guestlist = [ ];

    # userlist = umport {
    #   path = ./../../users;
    #   recursive = true;
    # };

    #adminusers = import ./../../users.nix;

    in
    
  let 
    admins = builtins.listToAttrs 
      (forEach adminusers (user: lib.nameValuePair 
        user.un {
          isNormalUser = true;
	        description = "${user.dn}";
	        initialPassword = "12w23e34r";
	        extraGroups = [ "wheel" "networkmanager" ];}));

    guests = builtins.listToAttrs 
      (forEach guestlist (user: lib.nameValuePair 
        user.un {
          isNormalUser = true;
	        description = "${user.dn}";
	        initialPassword = "skibidyT01l3t";
	        extraGroups = [ "networkmanager" ];}));
  in

  recursiveMerge [
    admins
    guests
  ];

}
