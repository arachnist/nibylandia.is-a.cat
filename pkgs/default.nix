self: super: {
  cass = super.callPackage ./cass.nix { };
  notbot = super.callPackage ./notbot.nix { };

  python3 = super.python3.override {
    packageOverrides = self: super: {
      pillow-with-headers = self.callPackage ./pillow-with-headers.nix { };
      minecraft-overviewer = self.callPackage ./minecraft-overviewer.nix { };
    };
  };
  python3Packages = self.python3.pkgs;
}
