{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "gdv-dl";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "vittsjo";
    repo = pname;
    rev = "5851f6c9774e872628bda5a3828f5d22a6e47130";
    hash = "sha256-1ybg/6yE92O9akf2imW4LoNSq+6W7EoYl9d2UU9weSA=";
  };

  phases = [ "installPhase" ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/index.js $out/bin/gdv-dl
  '';

  meta = with lib; {
    description = "Download video from Google Drive API url";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
