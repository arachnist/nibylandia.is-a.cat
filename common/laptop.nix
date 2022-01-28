{ config, lib, ... }:

{
  options = {
    my.laptop.enable = lib.mkEnableOption "Laptop specific configuration";
  };

  config = lib.mkIf config.my.laptop.enable {
    services.tlp.enable = true;
    services.upower.enable = true;
    powerManagement = {
      enable = true;
      powertop.enable = true;
      cpuFreqGovernor = "ondemand";
    };
    programs.light.enable = true;
    services.fwupd.enable = true;

    my.graphical.enable = lib.mkDefault true;
    my.boot.uefi.enable = lib.mkDefault true;
  };
}
