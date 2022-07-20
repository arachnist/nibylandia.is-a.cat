self: super: {
  cass = super.callPackage ./cass.nix { };
  notbot = super.callPackage ./notbot.nix { };

  python3 = super.python3.override {
    packageOverrides = self: super: {
      pillow-with-headers = self.callPackage ./pillow-with-headers.nix { };
      minecraft-overviewer = self.callPackage ./minecraft-overviewer.nix { };
    };
  };
  mpv-unwrapped = super.mpv-unwrapped.override { sixelSupport = true; };
  python3Packages = self.python3.pkgs;
  patched_sbattach = import <bootspec/installer/patched-sbattach.nix> { };
  bootspec-secureboot = self.callPackage ./bootspec-secureboot.nix { };
  
  mastodon-src = self.callPackage ./mastodon-src.nix { };
  mastodon = super.mastodon.override { srcOverride = self.mastodon-src; };
}
