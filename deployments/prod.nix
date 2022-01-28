let
  pkgs = import <nixpkgs> { };
  base = { network = { description = "*.nibylandia.lan infra"; }; };

  machines = import ../machines;

  # Modifies a machine definition to add deployment related information for
  # normal deployments (→ NixOS target server).
  makeNormalDeployment = name: machineMod: {
    name = "${name}.nibylandia.lan";
    value = { config, ... }: {
      _module.args = { machineName = name; };

      imports = [ machineMod ];
      networking.hostName = name;
      deployment.targetHost = "${name}.nibylandia.lan";
      deployment.targetUser = "root";
    };
  };
in base // (pkgs.lib.mapAttrs' makeNormalDeployment machines)
