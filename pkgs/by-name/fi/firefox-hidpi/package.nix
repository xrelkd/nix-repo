{
  lib,
  stdenvNoCC,
  makeWrapper,
  firefox,
}:

stdenvNoCC.mkDerivation {
  pname = "firefox-hidpi";
  version = firefox.version;

  phases = [ "installPhase" ];

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications

    makeWrapper ${firefox}/bin/firefox $out/bin/firefox --set GDK_DPI_SCALE 1.04

    cp ${firefox}/share/applications/firefox.desktop $out/share/applications/firefox.desktop

    substituteInPlace $out/share/applications/firefox.desktop \
      --replace-fail "Exec=firefox" "Exec=$out/bin/firefox"
  '';

  meta = with lib; {
    description = "Firefox wrapper with HiDPI scaling enabled";
    homepage = "https://www.mozilla.org/firefox/";
    license = licenses.mpl20;
    platforms = platforms.linux;
    mainProgram = "firefox";
  };
}
