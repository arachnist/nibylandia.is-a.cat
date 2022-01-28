# Still very WIP; needs roles/modules for the stuff that's actually running there

{ pkgs, ... }:

let my = import ../..;
in {
  imports = [ ./hardware.nix my.modules ];
  environment.systemPackages = with pkgs; [ notbot cass python3Packages.minecraft-overviewer ];
}
