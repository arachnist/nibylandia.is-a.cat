{ config, lib, ... }:

{
  options.my.postgresql.enable = lib.mkEnableOption "Enable postgresql DB";

  config = lib.mkIf config.my.postgresql.enable {
    services.postgresql = { enable = true; };
    services.prometheus.exporters.postgres = {
      enable = true;
      runAsLocalSuperUser = true;
      listenAddress = "127.0.0.1";
    };
  };
}
