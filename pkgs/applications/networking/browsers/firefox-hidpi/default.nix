{
  stdenvNoCC,
  makeWrapper,
  firefox,
}:

stdenvNoCC.mkDerivation {
  pname = "firefox-hidpi";
  version = "2026-08-05";

  phases = [ "installPhase" ];

  buildInputs = [ firefox ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications

    makeWrapper ${firefox}/bin/firefox $out/bin/firefox --set GDK_DPI_SCALE 1.04

    cp ${firefox}/share/applications/firefox.desktop $out/share/applications/firefox.desktop

    substituteInPlace $out/share/applications/firefox.desktop \
      --replace "Exec=firefox" "Exec=$out/bin/firefox"
  '';
}
