{ config, lib, pkgs, ... }:

let
  cfg = config.my.monitoring-server;
  grafana = config.services.grafana;
  filterValidPrometheus =
    filterAttrsListRecursive (n: v: !(n == "_module" || v == null));
  filterAttrsListRecursive = pred: x:
    if lib.isAttrs x then
      lib.listToAttrs (lib.concatMap (name:
        let v = x.${name};
        in if pred name v then
          [ (lib.nameValuePair name (filterAttrsListRecursive pred v)) ]
        else
          [ ]) (lib.attrNames x))
    else if lib.isList x then
      map (filterAttrsListRecursive pred) x
    else
      x;
  writePrettyJSON = name: x:
    pkgs.runCommandLocal name { } ''
      echo '${builtins.toJSON x}' | ${pkgs.jq}/bin/jq . > $out
    '';
  vmConfig = {
    scrape_configs =
      filterValidPrometheus config.services.prometheus.scrapeConfigs;
  };
  generatedPrometheusYml = writePrettyJSON "prometheus.yml" vmConfig;
  getEnabled = x:
    lib.concatMap (name: let v = x.${name}; in if v.enable then [ v ] else [ ])
    (lib.attrNames x);
  # TODO: add some magic to configure endpoints for all the other exporters
  localExporterEndpoints =
    map (x: x.listenAddress + ":" + builtins.toString x.port)
    (getEnabled config.services.prometheus.exporters);
in {
  options = {
    my.monitoring-server = {
      enable = lib.mkEnableOption "Enable monitoring server role";
      domain = lib.mkOption {
        type = lib.types.str;
        description = "External domain for monitoring services";
      };
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    ({
      services.victoriametrics = {
        enable = true;
        retentionPeriod = 12;
        listenAddress = "127.0.0.1:8428";
        extraOptions = [
          "-selfScrapeInterval=10s"
          "-promscrape.config=${generatedPrometheusYml}"
        ];
      };

      services.grafana = {
        enable = true;
        domain = cfg.domain;
        database = {
          user = "grafana";
          type = "postgres";
          host = "/run/postgresql";
        };
      };

      services.postgresql.ensureDatabases = [ "grafana" ];
      services.postgresql.ensureUsers = [{
        name = "grafana";
        ensurePermissions."DATABASE grafana" = "ALL PRIVILEGES";
      }];

      services.prometheus.exporters = {
        node = {
          enable = true;
          listenAddress = "127.0.0.1";
          enabledCollectors = [ "systemd" ];
        };
      };

      services.prometheus.scrapeConfigs = [{
        job_name = "local_exporters";
        scrape_interval = "10s";
        static_configs = [{ targets = localExporterEndpoints; }];
      }];
    })
    (lib.mkIf config.services.nginx.enable {
      services.nginx.virtualHosts."${cfg.domain}" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass =
            "http://${grafana.addr}:${builtins.toString grafana.port}";
          proxyWebsockets = true;
        };
      };
    })
  ]);
}
