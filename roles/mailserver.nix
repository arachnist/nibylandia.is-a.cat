{ config, lib, ... }:

let
  commit = "6e3a7b2ea6f0d68b82027b988aa25d3423787303";
  hash = "1i56llz037x416bw698v8j6arvv622qc0vsycd20lx3yx8n77n44";
  cfg = config.my.mailserver;
in {
  imports = [
    (builtins.fetchTarball {
      url =
        "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${commit}/nixos-mailserver-${commit}.tar.gz";
      sha256 = hash;
    })
  ];

  options = {
    my.mailserver = {
      enable = lib.mkEnableOption "Enable a mailserver";
      fqdn = lib.mkOption { type = lib.types.str; };
      domains = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of handled domains";
      };
      users = lib.mkOption { type = lib.types.attrs; };
    };
  };

  config = lib.mkIf cfg.enable {
    mailserver = {
      enable = true;
      fqdn = cfg.fqdn;
      domains = cfg.domains;
      certificateScheme = 3;
      loginAccounts = cfg.users;
    };
  };
}
