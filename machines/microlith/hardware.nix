{ config, lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  my.graphical.enable = true;
  my.boot.ryzen.enable = true;
  my.boot.uefi.enable = true;

  boot.initrd.availableKernelModules =
    [ "nvme" "xhci_pci" "ahci" "usbhid" "uas" "sd_mod" ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/71eb7f26-3872-45cc-8456-c801ab342017";
    fsType = "xfs";
  };

  boot.initrd.luks.devices."microlith".device =
    "/dev/disk/by-uuid/3b53f78f-4d3f-4b3b-b7c8-640fe450f122";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F0CC-B537";
    fsType = "vfat";
  };

  hardware.video.hidpi.enable = lib.mkDefault true;
}
