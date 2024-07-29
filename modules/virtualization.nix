{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [ 
   #==<< QEMU >>=======================>
    qemu
    quickemu 
    (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
      qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
    '')
  ];

}
