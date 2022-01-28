# Still very WIP; needs roles/modules for the stuff that's actually running there

{ pkgs, ... }:

let my = import ../..;
in {
  imports = [ ./hardware.nix my.modules ];
  my.monitoring-server = {
	enable = true;
	domain = "monitoring.is-a.cat";
  };
  my.nginx.enable = true;
  my.postgresql.enable = true;
}
