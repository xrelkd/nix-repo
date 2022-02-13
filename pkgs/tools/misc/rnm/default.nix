{ lib
, stdenvNoCC
, fetchFromGitHub
}:

stdenvNoCC.mkDerivation rec {
  pname = "rnm";
  version = "unstable-2022-02-13";

  src = fetchFromGitHub {
    owner = "bjarkt";
    repo = pname;
    rev = "d315bedcf883e308f766c0aca78cfdbfec995a32";
    sha256 = "sha256-9SeHYlFU9WeJNFXoJa/onhs+TlJ9hZJnkghd4/6t+q8=";
  };

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 $src/rnm $out/bin/rnm
  '';

  dontPatchShebangs = true;

  meta = with lib; {
    homepage = "https://github.com/bjarkt/rnm";
    description = "An easier to use rename utility for Linux";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
