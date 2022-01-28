# Still very WIP; needs roles/modules for the stuff that's actually running there

{ config, pkgs, ... }:

let my = import ../..;
in {
  imports = [ ./hardware.nix my.modules ];

  age.secrets.cassAuth.file = ../../secrets/cassAuth.age;
  age.secrets.minecraftRestic.file = ../../secrets/norkclubMinecraftRestic.age;

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
  my.minecraft-server = {
    enable = true;
    sshKeys = config.my.secrets.userDB.ar.keys ++ [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDOHWPbzvwXTftY1r0dXcYZxT9QBnQkwepdMn8PCAPlYvYwUObEj3rgYrYRFrtCRWZVrKAdqBxnH9/6S9w631Zs7tgqEeDHJsotZNZV3qip7qGjn9IqUHXqF95MUDJV21AeBAqQ1xalefwCkwf/vYLFn8dSnsnlfO+mtlHZOuBED+SB2U1eNrWY2e45v8m7PqSyTCbCu0F3wVcHGwRFsxWA598wf85UBRVcSWVcUydE9F+PCS9sGETkXiRUDcHWnup8uygs4xLa9RADubhdGkUbQE6m6yOjvHJWZ4ov59zJh+hmpszCwfmUw/k39T2TM7tbwUWxgc68qDyaMGQr/Wzd x10a94@Celestia"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDeJ+LSo3YXE6Jk6pGKL5om/VOi7XE5OvHA2U73V0pJXHa1bA4ityICeNqec2w8TSWSwTihJ4oAM7YLShkERNTcd1NWNHgUYova9nJ/nItFxrxDpTQsqK315u4d7nE+go09c85cyomHbDDcNVg9kJeCUjF+dr82N7JZfYVdQystOslOROYtl94GHuFHVOQyBRGeSztmakYvK1+3WV8dby6TfYG1l6uf6qLCg7q64zR4xDDP0KgfcrsusBQ6qYnKhop1fUTaW9NtEOQP/MhFLDp2YQmTsNJDiKAQpwwYLexWq4UcziXbnRfD56CHFHbW7Hu6Ltu35cHFKR2r9y4TBwTV crendgrim@gmx.de"
    ];
    backupSchedule = "*:0/15";
    backupAuthEnvFile = config.age.secrets.minecraftRestic.path;
    backupScript = ''
      export PATH="/run/current-system/sw/bin"
      /home/minecraft/minecraft-backup/backup.sh -w rcon -i /home/minecraft/survival/world -r  "${config.my.secrets.backups.minecraft.location}" -s "${config.my.secrets.backups.minecraft.RCONAuth}" -m -1
    '';
    overviewerConfigLocation = "/srv/minecraft-overviewer/survival/config.py";
    overviewerParallelism = 8;
    tcpPorts = [ 25565 25566 ];
    udpPorts = [ 19132 19133 25565 25566 ];
  };
}
