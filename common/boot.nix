{ config, lib, pkgs, ... }:

{
  options = {
    my.boot.uefi.enable = lib.mkEnableOption "Boot via UEFI";
    my.boot.ryzen.enable =
      lib.mkEnableOption "Enable AMD Ryzen-specific options";
  };

  config = lib.mkMerge [
    (lib.mkIf config.my.boot.uefi.enable {
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
    })
    (lib.mkIf config.my.boot.ryzen.enable {
      boot = {
        extraModulePackages = with config.boot.kernelPackages; [ zenpower ];
        blacklistedKernelModules = [ "k10temp" ];
        kernelModules = [ "zenpower" "kvm-amd" ];
      };
    })
    { boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; }
  ];
}
