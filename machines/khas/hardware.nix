{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  my.laptop.enable = true;
  my.boot.ryzen.enable = true;

  boot.initrd.availableKernelModules =
    [ "nvme" "ehci_pci" "xhci_pci" "rtsx_pci_sdmmc" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44b64c75-ef9b-4f62-8ac8-0d1d0536d52d";
    fsType = "btrfs";
  };

  boot.initrd.luks.devices."khas".device =
    "/dev/disk/by-uuid/20bc7edd-2803-48eb-bee4-90adcace7f64";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C091-50F9";
    fsType = "vfat";
  };
}
