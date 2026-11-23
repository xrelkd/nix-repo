{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
}:

let
  pname = "ionicons";
  version = "6.0.1";
in
stdenvNoCC.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "ionic-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UooZ+rnq7mxCzYQby2y7cOe/Clk8ir5ETOH3N2cPg8s=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 docs/fonts/ionicons.ttf $out/share/fonts/truetype/ionicons.ttf
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://ionicons.com";
    description = "Font from the Ionic mobile framework";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
