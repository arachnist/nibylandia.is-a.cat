{ fetchgit, applyPatches }: let
  src = fetchgit {
    url = "https://github.com/mastodon/mastodon.git";
    rev = "v3.5.3";
    sha256 = "1z0fgyvzz7nlbg2kaxsh53c4bq4y6n5f9r8lyfa7vzvz9nwrkqiq";
  };
in applyPatches {
  inherit src;
  patches = [
    ./mastodon-bump-note-length-limit-to-1000.patch
    ./mastodon-give-moderators-full-emoji-control.patch
  ];
}
