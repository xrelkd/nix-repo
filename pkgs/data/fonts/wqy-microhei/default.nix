{ lib, stdenvNoCC, fetchurl, dpkg }:

stdenvNoCC.mkDerivation rec {
  pname = "wqy-microhei";
  version = "0.2.0-beta-3";

  src = fetchurl {
    url = "mirror://ubuntu/pool/universe/f/fonts-wqy-microhei/fonts-${pname}_${version}_all.deb";
    hash = "sha256-54J7yhZHWgLyndelkgjBeQmSA3pD1kiWMgVyNi0b150=";
  };

  buildInputs = [ dpkg ];

  phases = [
    "unpackPhase"
    "installPhase"
  ];

  unpackPhase = ''
    dpkg-deb -x $src $TMPDIR
  '';

  installPhase = ''
    install -Dm644 $TMPDIR/usr/share/fonts/truetype/wqy/wqy-microhei.ttc $out/share/fonts/truetype/wqy/wqy-microhei.ttc
  '';

  meta = with lib; {
    description = "A (mainly) Chinese Unicode font";
    homepage = "http://wenq.org";
    license = licenses.asl20;
    platforms = platforms.all;
  };
}
