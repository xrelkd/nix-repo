{ lib, fetchzip }:

let
  pname = "cns11643";
  version = "103.1+20181001";
in
fetchzip {
  name = "${pname}-${version}";

  url = "mirror://ubuntu/pool/multiverse/f/fonts-cns11643/fonts-${pname}_${version}.orig.tar.xz";
  sha256 = "sha256-INi+k53UrAlxf96rtg4zeMD1jIqzoAam9UZCRbr2evU=";

  postFetch = ''
    tar -xJvf $downloadedFile --strip-components=1
    install -m444 -Dt $out/share/fonts/truetype *.ttf
  '';

  meta = with lib; {
    description = "Chinese Standard Interchange Code";
    homepage = "https://www.cns11643.gov.tw";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
  };
}
