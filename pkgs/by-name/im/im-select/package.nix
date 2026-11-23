{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "im-select";
  version = "unstable-2023-04-19";

  src =
    if stdenv.hostPlatform.isAarch64 then
      (fetchurl {
        url = "https://raw.githubusercontent.com/daipeihust/im-select/11ed9277fb3118b63b36cfca57c39fa4cc882512/macOS/out/apple/im-select";
        hash = "sha256-MbBlL421nvBpBs1qhjXcweYWKILoMAytSCqLW5f/8pA=";
      })
    else if stdenv.hostPlatform.isx86_64 then
      (fetchurl {
        url = "https://raw.githubusercontent.com/daipeihust/im-select/11ed9277fb3118b63b36cfca57c39fa4cc882512/macOS/out/intel/im-select";
        hash = "sha256-LeNx7tNev6XX644JF0nDdLOFZwnlWgOHlAmuWDFoePk=";
      })
    else
      throw "Unsupported architecture";

  dontBuild = true;
  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/im-select
    chmod +x $out/bin/im-select
  '';

  meta = with lib; {
    description = "Switch your input method through terminal";
    homepage = "https://github.com/daipeihust/im-select";
    license = licenses.mit;
    platforms = platforms.darwin;
    mainProgram = "im-select";
  };
}
