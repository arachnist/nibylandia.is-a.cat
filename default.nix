rec {
  common = import ./common;
  roles = import ./roles;
  secrets = import ./secrets;
  pkgs = import ./pkgs;

  modules = { imports = [ common roles secrets ]; };
}
