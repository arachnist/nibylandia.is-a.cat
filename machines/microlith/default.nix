{ ... }:

let my = import ../..;
in {
  imports = [ ./hardware.nix my.modules ];

  my.gaming-client.enable = true;
  my.boot.secureboot.enable = true;
}
