{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "gdv-dl";
  version = "0.0.1";
  phases = [ "installPhase" ];

  src = fetchFromGitHub {
    owner = "vittsjo";
    repo = pname;
    rev = "5851f6c9774e872628bda5a3828f5d22a6e47130";
    hash = "083rf17m2xnpjwc4mv4nxsmm50rfp1jqmxj7dayn7xw4mkzy09np";
  };

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
