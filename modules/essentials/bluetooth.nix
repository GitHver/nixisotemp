{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    bluez
    bluez-tools
    bluetuith
    blueman
  ];
  
}
