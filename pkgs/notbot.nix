{ fetchFromGitHub, buildGoModule, ... }:

buildGoModule rec {
  pname = "notbot";
  version = "0.0.3";

  src = fetchFromGitHub {
    owner = "arachnist";
    repo = pname;
    rev = "0ee9443824044228dc045095d967d0f71916f67a";
    sha256 = "jyoFiNAo9tS0bK47CjP2/v7G040Lg7G8Oxxr7gYFyfA=";
  };

  vendorSha256 = "sha256-gi6mrJW65tfWYScwRlPSvBartqfvVlGbR9GWfj9G4xE=";
  proxyVendor = true;
}
