{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation rec {
  pname = "im-select";
  version = "unstable-2024-04-21";

  src =
    if stdenv.isAarch64 then
      (fetchurl {
        url = "https://raw.githubusercontent.com/daipeihust/im-select/master/macOS/out/apple/im-select";
        hash = "sha256-MbBlL421nvBpBs1qhjXcweYWKILoMAytSCqLW5f/8pA=";
      })
    else
      stdenv.isx86_64 (fetchurl {
        url = "https://raw.githubusercontent.com/daipeihust/im-select/master/macOS/out/intel/im-select";
        hash = "sha256-LeNx7tNev6XX644JF0nDdLOFZwnlWgOHlAmuWDFoePk=";
      });

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

