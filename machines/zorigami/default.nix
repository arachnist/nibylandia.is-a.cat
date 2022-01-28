# Still very WIP; needs roles/modules for the stuff that's actually running there

{ config, pkgs, ... }:

let my = import ../..;
in {
  imports = [ ./hardware.nix my.modules ];

  age.secrets.cassAuth.file = ../../secrets/cassAuth.age;

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
  my.cass = {
    enable = true;
    fileStore = "/srv/www/arachnist.is-a.cat/c";
    urlBase = "https://ar.is-a.cat/c/";
    domain = "ar.is-a.cat";
    authFileLocation = config.age.secrets.cassAuth.path;
  };
}
