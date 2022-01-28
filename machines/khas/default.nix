{ ... }:

let my = import ../..;
in { imports = [ ./hardware.nix my.modules ]; }
