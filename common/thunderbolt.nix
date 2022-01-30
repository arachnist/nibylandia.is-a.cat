{ config, lib, ... }:

{
  options = {
    my.thunderbolt.enable = lib.mkEnableOption "Enable thunderbolt support";
  };

  config = lib.mkIf config.my.thunderbolt.enable {
    boot.kernelParams = [ "pci=realloc,assign-busses,hpbussize=0x33" ];
    services.hardware.bolt.enable = true;
  };
}
