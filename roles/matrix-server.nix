{ config, lib, ... }:

{
  options.my.matrix-server = {
    enable = lib.mkEnableOption "Enable a matrix server";
    serverName = lib.mkOption {
      type = lib.types.str;
      description = "matrix server name";
    };
  };

  config = lib.mkIf config.my.matrix-server.enable {
    services.matrix-conduit = {
      enable = true;
      settings.global = {
        trusted_servers = [ "matrix.org" "hackerspace.pl" ];
        server_name = config.my.matrix-server.serverName;
      };
    };

    services.nginx.virtualHosts.${config.my.matrix-server.serverName} = {
      enableACME = true;
      forceSSL = true;

      locations."/_matrix" = { proxyPass = "http://[::1]:6167"; };

      locations."/.well-known/matrix/server" = {
        return = ''200 "{\"m.server\":\"${config.my.matrix-server.serverName}:443\",\"m.homeserver\":{\"base_url\":\"https://${config.my.matrix-server.serverName}\"}}"'';
      };
    };
  };
}
