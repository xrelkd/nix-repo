{ stdenvNoCC, makeWrapper, chromium }:

stdenvNoCC.mkDerivation {
  pname = "chromium-hidpi";
  version = "2019-07-14";

  phases = [ "installPhase" ];

  buildInputs = [ chromium makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${chromium}/bin/chromium $out/bin/chromium \
      --add-flags "--force-device-scale-factor=1.5"
    makeWrapper ${chromium}/bin/chromium-browser $out/bin/chromium-browser \
      --add-flags "--force-device-scale-factor=1.5"
  '';
}
