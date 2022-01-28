{ ... }:

let
	my = import ./..;
in
{
  nixpkgs.overlays = [ my.pkgs ];
  documentation = {
    doc.enable = false;
    info.enable = false;
    man.enable = true;
    nixos.enable = true;
  };
}
