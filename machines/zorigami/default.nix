# Still very WIP; needs roles/modules for the stuff that's actually running there

{ config, pkgs, ... }:

let my = import ../..;
in {
  imports = [ ./hardware.nix my.modules ];
  my.monitoring-server = {
	enable = true;
	domain = "monitoring.is-a.cat";
  };
  my.nginx.enable = true;
  my.postgresql.enable = true;
  my.notbot = {
    enable = true;
    nickServPassword = config.my.secrets.userDB.notbot.irc.password;
    channels = config.my.secrets.userDB.notbot.irc.channels;
    jitsiChannels = config.my.secrets.userDB.notbot.irc.jitsiChannels;
    atChannel = config.my.secrets.userDB.notbot.irc.atChannel;
  };
}
