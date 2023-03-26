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

  hash = "sha256-UooZ+rnq7mxCzYQby2y7cOe/Clk8ir5ETOH3N2cPg8s=";

  downloadToTemp = true;

  postFetch = ''
    cd $out
    install -Dm644 docs/fonts/ionicons.ttf -t $out/share/fonts/truetype/
  '';


  meta = with lib; {
    homepage = "https://ionicons.com";
    description = "Font from the Ionic mobile framework";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
