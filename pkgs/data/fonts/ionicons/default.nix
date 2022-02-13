{ lib
, fetchFromGitHub
}:

let
  pname = "ionicons";
  version = "6.0.1";

in
fetchFromGitHub rec {
  owner = "ionic-team";
  repo = pname;
  rev = "v${version}";

  postFetch = ''
    tar -xf $downloadedFile

    install -Dm644 ${pname}-${version}/docs/fonts/ionicons.ttf -t $out/share/fonts/truetype/
  '';

  sha256 = "sha256-DoFsglxY/+CeBSxw6b1FRuMMrdLco3F1XCyUTmk0RBc=";

  meta = with lib; {
    homepage = "https://ionicons.com";
    description = "Font from the Ionic mobile framework";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
