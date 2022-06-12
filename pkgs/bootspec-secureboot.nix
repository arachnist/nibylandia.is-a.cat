{ rustPlatform, pkgs, ... }:

rustPlatform.buildRustPackage rec {
  pname = "bootspec-secureboot";
  version = "unreleased";
  src = builtins.fetchGit {
    url = "https://github.com/DeterminateSystems/bootspec-secureboot.git";
    ref = "main";
  };
  cargoSha256 = "sha256-BifoJS4BmVNNGaviycGtQpEF+Oe8dKBNU6j1+MWtods=";

  postPatch = ''
    substituteInPlace installer/build.rs \
      --replace "@patched_sbattach@" "${pkgs.patched_sbattach}"
  '';
}
