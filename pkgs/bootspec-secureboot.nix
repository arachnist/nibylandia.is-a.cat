{ rustPlatform, pkgs, ... }:

rustPlatform.buildRustPackage rec {
  pname = "bootspec-secureboot";
  version = "unreleased";
  src = /home/ar/scm/bootspec-secureboot;

  cargoSha256 = "sha256-PDTuBk0AgdG4tyTNG1TMm6Ba1uazK7U5jDVweCI8lCA=";

  postPatch = ''
    substituteInPlace installer/build.rs \
      --replace "@patched_sbattach@" "${pkgs.patched_sbattach}"
  '';
}
