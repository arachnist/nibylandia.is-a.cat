{ pkgs, ... }:

let my = import ../..;
in {
  imports = [ ./hardware.nix my.modules ];

  my.gaming-client.enable = true;
  my.boot.secureboot.enable = true;
  security.pam.enableFscrypt = true;
  virtualisation.libvirtd = {
    qemu.runAsRoot = false;
    enable = true;
  };
}
