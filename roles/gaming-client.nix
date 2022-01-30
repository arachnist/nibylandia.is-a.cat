{ config, lib, pkgs, ... }:

let
  cfg = config.my.gaming-client;
in {
  options.my.gaming-client = {
    enable = lib.mkEnableOption "Gaming client";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ steam ];

    # Firewall ports used by Steam in-home streaming.
    networking.firewall.allowedTCPPorts = [ 27036 27037 ];
    networking.firewall.allowedUDPPorts = [ 27031 27036 ];
  };
}
