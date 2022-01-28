{ fetchFromGitHub, buildGoPackage, ... }:

buildGoPackage rec {
  pname = "cass";
  version = "0.0.1";
  src = fetchFromGitHub {
    owner = "arachnist";
    repo = "cass";
    rev = "00b3536c5b546bb5b929b2562c86fee2869885a4";
    sha256 = "+ZGO/ZoGN+LdcPGWHjjZ/wpayFxnfKvxiVMaS0iNYr0=";
  };
  goPackagePath = "github.com/arachnist/cass";
}
