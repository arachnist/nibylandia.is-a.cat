{ config, lib, pkgs, ... }:

let cfg = config.my.mastodon;
in {
  options = {
    my.mastodon = {
      enable = lib.mkEnableOption "Enable mastodon";
      domain = lib.mkOption {
        type = lib.types.str;
        description = "Domain name for mastodon instance";
      };
      smtpUser = lib.mkOption {
        type = lib.types.str;
        description = "smtp user for mastodon";
      };
      smtpPasswordFile = lib.mkOption { type = lib.types.path; };
    };
  };

  config = lib.mkIf cfg.enable {
    services.mastodon = {
      enable = true;
      webProcesses = 4;
      localDomain = cfg.domain;
      configureNginx = true;
      smtp = {
        user = cfg.smtpUser;
        passwordFile = cfg.smtpPasswordFile;
        fromAddress = cfg.smtpUser;
        host = cfg.domain;
        createLocally = false;
        authenticate = true;
      };
      extraConfig = { EMAIL_DOMAIN_ALLOWLIST = cfg.domain; };
    };

    services.postgresql.ensureDatabases = [ "mastodon" ];
    services.postgresql.ensureUsers = [{
      name = "mastodon";
      ensurePermissions."DATABASE mastodon" = "ALL PRIVILEGES";
    }];

    services.nginx.virtualHosts.${cfg.domain}.locations."/about" = {
      return = "403";
    };
  };
}
