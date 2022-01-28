{ fetchFromGitHub, buildGoModule, ... }:

buildGoModule rec {
  pname = "notbot";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "arachnist";
    repo = pname;
    rev = "df0b22125370085f7cd5069f2323d80e1af24b72";
    sha256 = "OZixQYDM4r36dFqs+fEbn0Ll/qg1+OrHUTrmeM1zEyo=";
  };

  vendorSha256 = "sha256-jqxMTzTY9WpkHzW+AMJ5o9XoS0Rjde5weUPRDVnlBio=";
  proxyVendor = true;
}
