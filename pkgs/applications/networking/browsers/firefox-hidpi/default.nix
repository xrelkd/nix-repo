{
  stdenvNoCC,
  makeWrapper,
  firefox,
}:

stdenvNoCC.mkDerivation {
  pname = "firefox-hidpi";
  version = "2019-07-14";

  phases = [ "installPhase" ];

  buildInputs = [ firefox ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${firefox}/bin/firefox $out/bin/firefox --set GDK_DPI_SCALE 1.04
  '';
}
