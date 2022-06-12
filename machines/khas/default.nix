{ pkgs, ... }:

let my = import ../..;
in {
  imports = [ ./hardware.nix my.modules <bootspec/nixos-module.nix> ];

  my.gaming-client.enable = true;
  my.boot.secureboot.enable = true;
  boot.loader.secureboot = {
    enable = true;
    signingKeyPath = "/home/ar/secureboot-v2/DB.key";
    signingCertPath = "/home/ar/secureboot-v2/DB.crt";
  };
  my.boot.uefi.enable = false;
}
