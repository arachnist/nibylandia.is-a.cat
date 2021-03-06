# Still very WIP; needs roles/modules for the stuff that's actually running there

{ config, pkgs, lib, ... }:

let
  my = import ../..;
  userdb = config.my.secrets.userDB;
in {
  imports = [ ./hardware.nix my.modules ];
  my.boot.secureboot.enable = true;
  
  age.secrets.cassAuth = {
    file = ../../secrets/cassAuth.age;
    group = "nginx";
    mode = "440";
  };
  age.secrets.minecraftRestic.file = ../../secrets/norkclubMinecraftRestic.age;
  age.secrets.nextCloudAdmin = {
    file = ../../secrets/nextCloudAdmin.age;
    group = "nextcloud";
    mode = "440";
  };
  age.secrets.nextCloudExporter = {
    file = ../../secrets/nextCloudExporter.age;
    group = "nextcloud-exporter";
    mode = "440";
  };
  age.secrets.wgNibylandia.file = ../../secrets/wg/nibylandia_zorigami.age;

  age.secrets.arMail.file = ../../secrets/mail/ar.age;
  age.secrets.apoMail.file = ../../secrets/mail/apo.age;
  age.secrets.madargonMail.file = ../../secrets/mail/madargon.age;
  age.secrets.mastodonMail.file = ../../secrets/mail/mastodon.age;
  age.secrets.mastodonPlainMail = {
    group = "mastodon";
    mode = "440";
    file = ../../secrets/mail/mastodonPlain.age;
  };

  my.monitoring-server = {
    enable = true;
    domain = "monitoring.is-a.cat";
  };

  my.nginx.enable = true;

  my.postgresql.enable = true;

  my.notbot = {
    enable = true;
    nickServPassword = userdb.notbot.irc.password;
    channels = userdb.notbot.irc.channels;
    jitsiChannels = userdb.notbot.irc.jitsiChannels;
    spaceApiChannels = userdb.notbot.irc.spaceApiChannels;
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
    sshKeys = userdb.ar.keys ++ [
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

  my.irc = {
    enable = true;
    domain = "irc.is-a.cat";
  };

  my.nextcloud = {
    enable = true;
    domain = "cloud.is-a.cat";
    adminSecret = config.age.secrets.nextCloudAdmin.path;
    exporterSecret = config.age.secrets.nextCloudExporter.path;
  };

  my.mailserver = {
    enable = true;
    fqdn = "is-a.cat";
    domains = [ "is-a.cat" "i.am-a.cat" "rsg.enterprises" ];
    users.${userdb.ar.email} = {
      aliases = userdb.ar.emailAliases;
      hashedPasswordFile = config.age.secrets.arMail.path;
    };
    users.${userdb.apo.email} = {
      hashedPasswordFile = config.age.secrets.apoMail.path;
    };
    users.${userdb.madargon.email} = {
      hashedPasswordFile = config.age.secrets.madargonMail.path;
    };
    users."mastodon@is-a.cat" = {
      hashedPasswordFile = config.age.secrets.mastodonMail.path;
    };
  };

  my.matrix-server = {
    enable = true;
    serverName = "is-a.cat";
  };

  my.mastodon = {
    enable = true;
    domain = "is-a.cat";
    smtpUser = "mastodon@is-a.cat";
    smtpPasswordFile = config.age.secrets.mastodonPlainMail.path;
  };

  # need to figure out something fancy about network configuration
  networking.useDHCP = false;
  networking.interfaces.enp36s0f1.useDHCP = false;
  networking.interfaces.enp38s0.useDHCP = false;
  networking.interfaces.enp39s0.useDHCP = false;
  networking.interfaces.enp42s0f3u5u3c2.useDHCP = false;
  networking.tempAddresses = "disabled";
  networking.interfaces.enp36s0f0 = {
    useDHCP = false;
    ipv4 = {
      addresses = [{
        address = "185.236.240.137";
        prefixLength = 31;
      }];
      routes = [{
        address = "0.0.0.0";
        prefixLength = 0;
        via = "185.236.240.136";
      }];
    };
    ipv6 = {
      addresses = [{
        address = "2a0d:eb00:8007::10";
        prefixLength = 64;
      }];
      routes = [{
        address = "::";
        prefixLength = 0;
        via = "2a0d:eb00:8007::1";
      }];
    };
  };
  networking.nameservers = [
    "8.8.8.8"
    "8.8.4.4"
    "1.1.1.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
    "2001:4860:4860::8888"
  ];
  boot.kernel.sysctl = {
    "net.ipv6.conf.all.accept_ra" = false;
    "net.ipv6.conf.default.accept_ra" = false;
    "net.ipv4.conf.all.forwarding" = true;
  };
  networking.wireguard.interfaces = {
    wg-nibylandia = {
      ips = [ "10.255.255.1/24" ];
      privateKeyFile = config.age.secrets.wgNibylandia.path;
      listenPort = 51315;

      peers = [
        {
          publicKey = "g/XhdVYsegn7Pp58Y1HFNxp4jhmA8YjRDg8W8J6swCw=";
          endpoint = "i.am-a.cat:51315";
          allowedIPs =
            [ "10.255.255.2/32" "192.168.20.0/24" "192.168.24.0/24" ];
          persistentKeepalive = 15;
        }
        {
          publicKey = "ubxtr3zW9F/ofjaQFnj6XpYcrOvTdOSW5wv06+VEehU=";
          allowedIPs = [ "10.255.255.3/32" ];
          persistentKeepalive = 15;
        }
        {
          publicKey = "tVH3q1AJZKsitYmASdaogMCBwhMCd8oSuDY2POpiUiY=";
          allowedIPs = [ "10.255.255.4/32" ];
          persistentKeepalive = 15;
        }
      ];
    };
  };
  networking.firewall.allowedUDPPorts = [ 51315 ];

  # Need to figure out something fancy here too
  services.nginx.virtualHosts = {
    "s.nork.club" = {
      forceSSL = true;
      enableACME = true;
      root = "/srv/www/s.nork.club";
    };
    "ar.is-a.cat" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = { root = "/srv/www/arachnist.is-a.cat"; };
    };
    "arachnist.is-a.cat" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = { root = "/srv/www/arachnist.is-a.cat"; };
    };
    "brata.zajeba.li" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = { root = "/srv/www/brata.zajeba.li"; };
    };
  };
}
