{
  lib,
  stdenvNoCC,
  fetchurl,
}:

stdenvNoCC.mkDerivation rec {
  pname = "cns11643-fonts";
  version = "103.1+20181001";

  src = fetchurl {
    url = "mirror://ubuntu/pool/multiverse/f/fonts-cns11643/fonts-cns11643_${version}.orig.tar.xz";
    hash = "sha256-7Rauz+ndU5h/tE1l3tc6+sH+s0WrwtAoKxrexQLMW08=";
  };

  installPhase = ''
    runHook preInstall
    install -d $out/share/fonts/truetype
    install -m444 *.ttf $out/share/fonts/truetype/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Chinese Standard Interchange Code (TrueType fonts)";
    homepage = "https://www.cns11643.gov.tw";
    license = licenses.free;
    platforms = platforms.all;
  };
}
